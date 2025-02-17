import { Injectable } from '@nestjs/common';
import { WebsocketStream } from '@binance/connector-typescript';
import { Model, Connection, Types } from 'mongoose';
import { InjectModel, InjectConnection } from '@nestjs/mongoose';
import { decimal128Neg, decimal128Mul } from 'src/utils/decimal128.util';
import { Order } from './schemas/order.schema';
import { CreateOrderDto } from './dto/create-order.dto';
import { MiniTicker } from './dto/mini-ticker.dto';
import { Balance } from 'src/balance/schemas/balance.schema';
import { SymbolInfo } from 'src/exchangeInfo/schemas/symbolInfo.schema';
import { CancelOrdersDto } from './dto/cancel-orders.dto';
import { CancelOrderDto } from './dto/cancel-order.dto';

@Injectable()
export class OrderService {
  private wsClient: WebsocketStream;

  constructor(
    @InjectModel(Order.name) private orderModel: Model<Order>,
    @InjectModel(SymbolInfo.name) private symbolInfoModel: Model<SymbolInfo>,
    @InjectModel(Balance.name) private balanceModel: Model<Balance>,
    @InjectConnection() private readonly connection: Connection,
  ) {}

  onModuleInit() {
    this.wsClient = new WebsocketStream({
      callbacks: {
        open: () => console.debug('Connected to WebSocket server'),
        close: () => console.debug('Disconnected from WebSocket server'),
        message: async (data) => {
          try {
            const miniTickers = JSON.parse(data)['data'] as MiniTicker[];
            await this.orderModel.bulkWrite(
              miniTickers.map(({ s: symbol, c: closePrice }) => ({
                updateMany: {
                  filter: {
                    symbol,
                    status: 'NEW',
                    $or: [
                      {
                        side: 'BUY',
                        price: { $gte: new Types.Decimal128(closePrice) },
                      },
                      {
                        side: 'SELL',
                        price: { $lte: new Types.Decimal128(closePrice) },
                      },
                    ],
                  },
                  update: {
                    $set: {
                      status: 'FILLED',
                      executionPrice: new Types.Decimal128(closePrice),
                    },
                  },
                },
              })),
            );
          } catch (error) {
            console.error(error);
          }
        },
      },
      wsURL: process.env.BINANCE_WS_URL,
      combinedStreams: true,
    });
    this.wsClient.subscribe(['!miniTicker@arr']);
  }

  async createOrder(createOrderDto: CreateOrderDto): Promise<Order> {
    const session = await this.connection.startSession();
    session.startTransaction();
    try {
      const { userId, symbol, side, price, quantity } = createOrderDto;
      const symbolInfo = await this.symbolInfoModel.findOne({
        symbol,
      });
      if (!symbolInfo) {
        throw new Error('Invalid symbol');
      }
      const priceDec = new Types.Decimal128(price);
      const quantityDec = new Types.Decimal128(quantity);
      switch (side) {
        case 'BUY':
          const quoteOrderQty = decimal128Mul(priceDec, quantityDec);
          const userBalance = await this.balanceModel.findOneAndUpdate(
            {
              userId,
              asset: symbolInfo.quoteAsset,
              free: { $gte: quoteOrderQty },
            },
            {
              $inc: {
                free: decimal128Neg(quoteOrderQty),
                locked: quoteOrderQty,
              },
            },
            { session },
          );
          if (!userBalance) {
            throw new Error('Insufficient balance');
          }
          break;

        case 'SELL':
          const userBalanceAsset = await this.balanceModel.findOneAndUpdate(
            {
              userId,
              asset: symbolInfo.baseAsset,
              free: { $gte: quantityDec },
            },
            {
              $inc: {
                free: decimal128Neg(quantityDec),
                locked: quantityDec,
              },
            },
            { session },
          );
          if (!userBalanceAsset) {
            throw new Error('Insufficient balance');
          }
          break;

        default:
          throw new Error('Invalid order side');
      }
      const createdOrder = new this.orderModel({
        ...createOrderDto,
        price: priceDec,
        quantity: quantityDec,
      });
      const order = await createdOrder.save({ session });
      await session.commitTransaction();
      return order;
    } catch (error) {
      await session.abortTransaction();
      throw error;
    } finally {
      session.endSession();
    }
  }

  async cancelOrder(cancelOrderDto: CancelOrderDto): Promise<void> {
    const session = await this.connection.startSession();
    session.startTransaction();
    try {
      const { userId, orderId } = cancelOrderDto;
      const order = await this.orderModel.findOneAndUpdate(
        { userId, orderId, status: 'NEW' },
        {
          $set: {
            status: 'CANCELLED',
          },
        },
      );
      if (!order) {
        throw new Error('Invalid order');
      }
      const symbolInfo = await this.symbolInfoModel.findOne({
        symbol: order.symbol,
      });
      if (!symbolInfo) {
        throw new Error('Invalid symbol');
      }
      switch (order.side) {
        case 'BUY':
          const quoteLockedQty = decimal128Mul(order.price, order.quantity);
          await this.balanceModel.updateOne(
            { userId, asset: symbolInfo.quoteAsset },
            {
              $inc: {
                free: quoteLockedQty,
                locked: decimal128Neg(quoteLockedQty),
              },
            },
            { session },
          );
          break;
        case 'SELL':
          await this.balanceModel.updateOne(
            { userId, asset: symbolInfo.baseAsset },
            {
              $inc: {
                free: order.quantity,
                locked: decimal128Neg(order.quantity),
              },
            },
            { session },
          );
          break;
        default:
          throw new Error('Invalid side');
      }
      await session.commitTransaction();
    } catch (error) {
      await session.abortTransaction();
      throw error;
    } finally {
      session.endSession();
    }
  }

  async cancelOrders(cancelOrdersDto: CancelOrdersDto): Promise<void> {
    const session = await this.connection.startSession();
    session.startTransaction();
    try {
      const { userId, symbol } = cancelOrdersDto;
      const symbolInfo = await this.symbolInfoModel.findOne({ symbol });
      if (!symbolInfo) {
        throw new Error('Invalid symbol');
      }
      const orders = await this.orderModel.find({
        userId,
        symbol,
        status: 'NEW',
      });
      await this.orderModel.updateMany(
        {
          userId,
          symbol,
          status: 'NEW',
        },
        {
          $set: {
            status: 'CANCELLED',
          },
        },
      );
      for (const order of orders) {
        switch (order.side) {
          case 'BUY':
            const quoteLockedQty = decimal128Mul(order.price, order.quantity);
            await this.balanceModel.updateOne(
              { userId, asset: symbolInfo.quoteAsset },
              {
                $inc: {
                  free: quoteLockedQty,
                  locked: decimal128Neg(quoteLockedQty),
                },
              },
              { session },
            );
            break;
          case 'SELL':
            await this.balanceModel.updateOne(
              { userId, asset: symbolInfo.baseAsset },
              {
                $inc: {
                  free: order.quantity,
                  locked: decimal128Neg(order.quantity),
                },
              },
              { session },
            );
            break;
          default:
            throw new Error('Invalid side');
        }
      }
      await session.commitTransaction();
    } catch (error) {
      await session.abortTransaction();
      throw error;
    } finally {
      session.endSession();
    }
  }
}
