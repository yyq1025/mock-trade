import { Injectable } from '@nestjs/common';
import { WebsocketStream } from '@binance/connector-typescript';
import { Model, Connection } from 'mongoose';
import { InjectModel, InjectConnection } from '@nestjs/mongoose';
import Decimal from 'decimal.js';
import * as Pusher from 'pusher';
import { Order } from './schemas/order.schema';
import { CreateOrderDto } from './dto/create-order.dto';
import { MiniTicker } from './dto/mini-ticker.dto';
import { Balance } from 'src/balance/schemas/balance.schema';
import { SymbolInfo } from 'src/exchangeInfo/schemas/symbolInfo.schema';
import { CancelOrderDto } from './dto/cancel-order.dto';
import { GetOpenOrdersDto } from './dto/get-open-orders.dto';
import { GetTradeHistoryDto } from './dto/get-trade-history.dto';
import { PusherService } from 'src/pusher/pusher.service';

@Injectable()
export class OrderService {
  private wsClient: WebsocketStream;

  constructor(
    @InjectModel(Order.name) private orderModel: Model<Order>,
    @InjectModel(SymbolInfo.name) private symbolInfoModel: Model<SymbolInfo>,
    @InjectModel(Balance.name) private balanceModel: Model<Balance>,
    @InjectConnection() private readonly connection: Connection,
    private readonly pusherService: PusherService,
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
              miniTickers.map(({ s: symbol, c: closePrice }) => {
                const closePriceDec = new Decimal(closePrice).toString();
                return {
                  updateMany: {
                    filter: {
                      symbol,
                      status: 'NEW',
                      $or: [
                        {
                          side: 'BUY',
                          $expr: {
                            $gte: [
                              { $toDecimal: '$price' },
                              { $toDecimal: closePriceDec },
                            ],
                          },
                        },
                        {
                          side: 'SELL',
                          $expr: {
                            $lte: [
                              { $toDecimal: '$price' },
                              { $toDecimal: closePriceDec },
                            ],
                          },
                        },
                      ],
                    },
                    update: [
                      {
                        $set: {
                          status: 'FILLED',
                          executionPrice: closePriceDec,
                          exeQuoteQty: {
                            $toString: {
                              $multiply: [
                                { $toDecimal: '$quantity' },
                                { $toDecimal: closePriceDec },
                              ],
                            },
                          },
                        },
                      },
                    ],
                  },
                };
              }),
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

    this.orderModel
      .watch([{ $match: { operationType: 'update' } }], {
        fullDocument: 'updateLookup',
      })
      .on('change', async (change) => {
        if (
          change.fullDocument.status !== 'FILLED' &&
          change.fullDocument.status !== 'CANCELLED'
        ) {
          return;
        }
        const { userId, symbol, side, quantity, exeQuoteQty } =
          change.fullDocument;
        const symbolInfo = await this.symbolInfoModel.findOne({ symbol });
        if (!symbolInfo) {
          throw new Error('Symbol info not found');
        }
        const { baseAsset, quoteAsset } = symbolInfo;
        const session = await this.connection.startSession();
        session.startTransaction();
        try {
          await this.balanceModel.updateMany(
            { userId },
            {
              $pull: {
                balanceChanges: { orderId: change.fullDocument.orderId },
              },
            },
            { session },
          );
          if (change.fullDocument.status === 'FILLED') {
            switch (side) {
              case 'BUY':
                await this.balanceModel.updateOne(
                  { userId, asset: quoteAsset },
                  {
                    $addToSet: {
                      balanceChanges: {
                        orderId: change.fullDocument.orderId,
                        free: `-${exeQuoteQty}`,
                        locked: '0',
                      },
                    },
                  },
                  { upsert: true, session },
                );
                await this.balanceModel.updateOne(
                  { userId, asset: baseAsset },
                  {
                    $addToSet: {
                      balanceChanges: {
                        orderId: change.fullDocument.orderId,
                        free: quantity,
                        locked: '0',
                      },
                    },
                  },
                  { upsert: true, session },
                );
                break;
              case 'SELL':
                await this.balanceModel.updateOne(
                  { userId, asset: baseAsset },
                  {
                    $addToSet: {
                      balanceChanges: {
                        orderId: change.fullDocument.orderId,
                        free: `-${quantity}`,
                        locked: '0',
                      },
                    },
                  },
                  { upsert: true, session },
                );
                await this.balanceModel.updateOne(
                  { userId, asset: quoteAsset },
                  {
                    $addToSet: {
                      balanceChanges: {
                        orderId: change.fullDocument.orderId,
                        free: exeQuoteQty,
                        locked: '0',
                      },
                    },
                  },
                  { upsert: true, session },
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
        this.pusherService
          .getPusher()
          .trigger(userId, 'order', change.fullDocument);
      });
  }

  async createOrder(createOrderDto: CreateOrderDto): Promise<void> {
    const { userId, symbol, side, price, quantity } = createOrderDto;
    const symbolInfo = await this.symbolInfoModel.findOne({
      symbol,
    });
    if (!symbolInfo) {
      throw new Error('Invalid symbol');
    }
    const quoteOrderQty = Decimal.mul(price, quantity).toString();
    const session = await this.connection.startSession();
    session.startTransaction();
    try {
      switch (side) {
        case 'BUY':
          const quoteBalance = await this.balanceModel.findOne(
            { userId, asset: symbolInfo.quoteAsset },
            {},
            { session },
          );
          if (
            !quoteBalance ||
            new Decimal(quoteBalance.free).lt(quoteOrderQty)
          ) {
            throw new Error('Insufficient balance');
          }
          const buyOrder = await new this.orderModel({
            ...createOrderDto,
            quoteOrderQty,
          }).save({ session });
          await this.balanceModel.updateOne(
            { userId, asset: symbolInfo.quoteAsset },
            {
              $addToSet: {
                balanceChanges: {
                  orderId: buyOrder.orderId,
                  free: `-${quoteOrderQty}`,
                  locked: quoteOrderQty,
                },
              },
            },
            { upsert: true, session },
          );
          break;

        case 'SELL':
          const baseBalance = await this.balanceModel.findOne(
            { userId, asset: symbolInfo.baseAsset },
            {},
            { session },
          );
          if (!baseBalance || new Decimal(baseBalance.free).lt(quantity)) {
            throw new Error('Insufficient balance');
          }
          const sellOrder = await new this.orderModel({
            ...createOrderDto,
            quoteOrderQty,
          }).save({ session });
          await this.balanceModel.updateOne(
            { userId, asset: symbolInfo.baseAsset },
            {
              $addToSet: {
                balanceChanges: {
                  orderId: sellOrder.orderId,
                  free: `-${quantity}`,
                  locked: quantity,
                },
              },
            },
            { upsert: true, session },
          );
          break;

        default:
          throw new Error('Invalid order side');
      }
      await session.commitTransaction();
    } catch (error) {
      await session.abortTransaction();
      throw error;
    } finally {
      session.endSession();
    }
  }

  async getOpenOrders(getOpenOrdersDto: GetOpenOrdersDto): Promise<Order[]> {
    const { userId } = getOpenOrdersDto;
    return this.orderModel
      .find({ userId, status: 'NEW' })
      .populate('symbolInfo')
      .exec();
  }

  async getTradeHistory(
    getTradeHistoryDto: GetTradeHistoryDto,
  ): Promise<Order[]> {
    const { userId } = getTradeHistoryDto;
    return this.orderModel
      .find({ userId, status: 'FILLED' })
      .populate('symbolInfo')
      .exec();
  }

  async cancelOrder(cancelOrderDto: CancelOrderDto): Promise<void> {
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
  }
}
