import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import * as mongoose from 'mongoose';
import { Order } from '../../order/schemas/order.schema';

export type UserDocument = mongoose.HydratedDocument<User>;

@Schema()
export class User {
  // @Prop()
  // userId: string;

  @Prop()
  email: string;

  @Prop({ type: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Order' }] })
  orders: Order[];
}

export const UserSchema = SchemaFactory.createForClass(User);
