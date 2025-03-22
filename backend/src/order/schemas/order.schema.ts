import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { nanoid } from 'nanoid';
import { User } from '../../user/schemas/user.schema';
import { SymbolInfo } from 'src/exchangeInfo/schemas/symbolInfo.schema';

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

@Schema({
  timestamps: true,
  toObject: { getters: false, virtuals: ['user'] },
  toJSON: { getters: true, virtuals: ['symbolInfo'] },
})
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

  @Prop({ type: String, required: false })
  quantity: string;

  @Prop({ type: String, required: false })
  quoteOrderQty: string;

  @Prop({ type: String, required: false })
  price: string;

  @Prop({ type: String, required: false })
  executionPrice: string;

  @Prop({ type: String, required: false })
  exeQuoteQty: string;
}

export const OrderSchema = SchemaFactory.createForClass(Order);

OrderSchema.virtual('user', {
  ref: User.name,
  localField: 'userId',
  foreignField: 'userId',
  justOne: true,
});

OrderSchema.virtual('symbolInfo', {
  ref: SymbolInfo.name,
  localField: 'symbol',
  foreignField: 'symbol',
  justOne: true,
});
