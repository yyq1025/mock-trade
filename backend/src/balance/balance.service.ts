import { Injectable } from '@nestjs/common';
import { InjectModel, InjectConnection } from '@nestjs/mongoose';
import { Model, Connection } from 'mongoose';
import { Order } from 'src/order/schemas/order.schema';
import { Balance } from './schemas/balance.schema';
import { SymbolInfo } from 'src/exchangeInfo/schemas/symbolInfo.schema';
import { PusherService } from 'src/pusher/pusher.service';

@Injectable()
export class BalanceService {
  constructor(
    @InjectModel(Balance.name) private balanceModel: Model<Balance>,
    private readonly pusherService: PusherService,
  ) {}

  onModuleInit() {
    this.balanceModel
      .watch([{ $match: { operationType: 'update' } }], {
        fullDocument: 'updateLookup',
      })
      .on('change', async (change) => {
        if (change?.fullDocument?.userId) {
          this.pusherService
            .getPusher()
            .trigger(
              change.fullDocument.userId,
              'balance',
              change.fullDocument,
            );
        }
      });
  }
}
