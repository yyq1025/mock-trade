import { Module } from '@nestjs/common';
import { BalanceService } from './balance.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Balance, BalanceSchema } from './schemas/balance.schema';
import { Order, OrderSchema } from 'src/order/schemas/order.schema';
import {
  SymbolInfo,
  SymbolInfoSchema,
} from 'src/exchangeInfo/schemas/symbolInfo.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Balance.name, schema: BalanceSchema },
      { name: Order.name, schema: OrderSchema },
      { name: SymbolInfo.name, schema: SymbolInfoSchema },
    ]),
  ],
  providers: [BalanceService],
})
export class BalanceModule {}
