import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { OrderService } from './order.service';
import { OrderController } from './order.controller';
import { Order, OrderSchema } from './schemas/order.schema';
import { Balance, BalanceSchema } from 'src/balance/schemas/balance.schema';
import {
  SymbolInfo,
  SymbolInfoSchema,
} from 'src/exchangeInfo/schemas/symbolInfo.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Order.name, schema: OrderSchema },
      { name: SymbolInfo.name, schema: SymbolInfoSchema },
      { name: Balance.name, schema: BalanceSchema },
    ]),
  ],
  providers: [OrderService],
  controllers: [OrderController],
})
export class OrderModule {}
