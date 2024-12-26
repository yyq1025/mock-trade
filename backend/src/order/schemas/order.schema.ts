import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import * as mongoose from 'mongoose';
import { nanoid } from 'nanoid';
import { User } from '../../user/schemas/user.schema';

export type OrderDocument = mongoose.HydratedDocument<Order>;

export enum OrderType {
  LIMIT = 'LIMIT',
  MARKET = 'MARKET',
}

export enum OrderSide {
  BUY = 'BUY',
  SELL = 'SELL',
}

export enum OrderStatus {
  OPEN = 'OPEN',
  FILLED = 'FILLED',
  CANCELLED = 'CANCELLED',
}

@Schema({ timestamps: true })
export class Order {
  @Prop({ unique: true, default: () => nanoid() })
  orderId: string;

  @Prop({ type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true })
  user: User;

  @Prop({ required: true })
  symbol: string;

  @Prop({ type: String, enum: OrderType, required: true })
  orderType: OrderType;

  @Prop({ type: String, enum: OrderSide, required: true })
  side: OrderSide;

  @Prop({ type: String, enum: OrderStatus, default: OrderStatus.OPEN })
  status: OrderStatus;

  @Prop({ required: false })
  quantity: number;

  @Prop({ required: false })
  quoteOrderQty: number;

  @Prop({ required: false })
  price: number;

  @Prop({ required: false })
  executionPrice: number;
}

export const OrderSchema = SchemaFactory.createForClass(Order);
