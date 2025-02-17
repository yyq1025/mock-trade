import { Injectable } from '@nestjs/common';
import { InjectModel, InjectConnection } from '@nestjs/mongoose';
import { Model, Connection } from 'mongoose';
import { Order } from 'src/order/schemas/order.schema';
import { Balance } from './schemas/balance.schema';
import { SymbolInfo } from 'src/exchangeInfo/schemas/symbolInfo.schema';
import {
  decimal128Mul,
  decimal128Neg,
  decimal128Sub,
} from 'src/utils/decimal128.util';

@Injectable()
export class BalanceService {
  constructor(
    @InjectModel(Order.name) private orderModel: Model<Order>,
    @InjectModel(Balance.name) private balanceModel: Model<Balance>,
    @InjectModel(SymbolInfo.name) private symbolInfoModel: Model<SymbolInfo>,
    @InjectConnection() private readonly connection: Connection,
  ) {}

  onModuleInit() {
    this.orderModel
      .watch([{ $match: { operationType: 'update' } }], {
        fullDocument: 'updateLookup',
      })
      .on('change', async (change) => {
        if (change.fullDocument.status !== 'FILLED') {
          return;
        }
        const session = await this.connection.startSession();
        session.startTransaction();
        try {
          const { userId, symbol, side, price, quantity, executionPrice } =
            change.fullDocument;
          const symbolInfo = await this.symbolInfoModel.findOne({ symbol });
          if (!symbolInfo) {
            throw new Error('Symbol info not found');
          }
          const { baseAsset, quoteAsset } = symbolInfo;
          switch (side) {
            case 'BUY':
              const quoteLockedQty = decimal128Mul(price, quantity);
              const quoteExeQty = decimal128Mul(executionPrice, quantity);
              await this.balanceModel.updateOne(
                { userId, asset: quoteAsset },
                {
                  $inc: {
                    free: decimal128Sub(quoteLockedQty, quoteExeQty),
                    locked: decimal128Neg(quoteLockedQty),
                  },
                },
                { session },
              );
              await this.balanceModel.updateOne(
                { userId, asset: baseAsset },
                {
                  $inc: {
                    free: quantity,
                  },
                },
                { upsert: true, session },
              );
              break;
            case 'SELL':
              await this.balanceModel.updateOne(
                { userId, asset: baseAsset },
                {
                  $inc: {
                    locked: decimal128Neg(quantity),
                  },
                },
                { session },
              );
              await this.balanceModel.updateOne(
                { userId, asset: quoteAsset },
                {
                  $inc: {
                    free: decimal128Mul(executionPrice, quantity),
                  },
                },
                { upsert: true, session },
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
      });
  }
}
