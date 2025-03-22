import { Module } from '@nestjs/common';
import { BalanceService } from './balance.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Balance, BalanceSchema } from './schemas/balance.schema';
import { PusherModule } from 'src/pusher/pusher.module';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Balance.name, schema: BalanceSchema }]),
    PusherModule,
  ],
  providers: [BalanceService],
})
export class BalanceModule {}
