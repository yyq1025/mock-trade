import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { nanoid } from 'nanoid';
import { User } from '../../user/schemas/user.schema';

export type OrderDocument = HydratedDocument<Order>;

export enum OrderType {
  LIMIT = 'LIMIT',
  MARKET = 'MARKET',
}

export enum OrderSide {
  BUY = 'BUY',
  SELL = 'SELL',
}

export enum OrderStatus {
  NEW = 'NEW',
  FILLED = 'FILLED',
  CANCELLED = 'CANCELLED',
}

@Schema({ timestamps: true, toObject: { virtuals: ['user'] } })
export class Order {
  @Prop({ unique: true, default: () => nanoid() })
  orderId: string;

  @Prop({ type: String, required: true })
  userId: string;

  @Prop({ required: true })
  symbol: string;

  @Prop({ type: String, enum: OrderType, required: true })
  orderType: OrderType;

  @Prop({ type: String, enum: OrderSide, required: true })
  side: OrderSide;

  @Prop({ type: String, enum: OrderStatus, default: OrderStatus.NEW })
  status: OrderStatus;

  @Prop({ type: Types.Decimal128, required: false })
  quantity: Types.Decimal128;

  @Prop({ required: false })
  quoteOrderQty: number;

  @Prop({ type: Types.Decimal128, required: false })
  price: Types.Decimal128;

  @Prop({ type: Types.Decimal128, required: false })
  executionPrice: Types.Decimal128;
}

export const OrderSchema = SchemaFactory.createForClass(Order);

OrderSchema.virtual('user', {
  ref: User.name,
  localField: 'userId',
  foreignField: 'userId',
  justOne: true,
});
