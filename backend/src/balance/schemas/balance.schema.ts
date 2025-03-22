import { Prop, Schema, SchemaFactory, Virtual } from '@nestjs/mongoose';
import Decimal from 'decimal.js';
import { HydratedDocument, Types } from 'mongoose';

@Schema()
export class BalanceChange {
  @Prop({ required: true })
  orderId: string;

  @Prop()
  free: string;

  @Prop()
  locked: string;
}

export const BalanceChangeSchema = SchemaFactory.createForClass(BalanceChange);

export type BalanceDocument = HydratedDocument<Balance>;

@Schema({
  toObject: { virtuals: ['free', 'locked'] },
  toJSON: { virtuals: ['free', 'locked'] },
})
export class Balance {
  @Prop({ type: String, required: true })
  userId: string;

  @Prop({ required: true })
  asset: string;

  @Prop({ type: [BalanceChange], default: [] })
  balanceChanges: BalanceChange[];

  @Virtual({
    get: function (this: Balance) {
      return this.balanceChanges.reduce(
        (acc, change) => Decimal.add(acc, change.free).toString(),
        '0',
      );
    },
  })
  free: string;

  @Virtual({
    get: function (this: Balance) {
      return this.balanceChanges.reduce(
        (acc, change) => Decimal.add(acc, change.locked).toString(),
        '0',
      );
    },
  })
  locked: string;
}

export const BalanceSchema = SchemaFactory.createForClass(Balance);

BalanceSchema.index({ userId: 1, asset: 1 }, { unique: true });
