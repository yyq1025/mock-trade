import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';

export type BalanceDocument = HydratedDocument<Balance>;

@Schema()
export class Balance {
  @Prop({ type: String, required: true })
  userId: string;

  @Prop({ required: true })
  asset: string;

  @Prop({ type: Types.Decimal128, default: new Types.Decimal128('0') })
  free: Types.Decimal128;

  @Prop({ type: Types.Decimal128, default: new Types.Decimal128('0') })
  locked: Types.Decimal128;
}

export const BalanceSchema = SchemaFactory.createForClass(Balance);

BalanceSchema.index({ userId: 1, asset: 1 }, { unique: true });
