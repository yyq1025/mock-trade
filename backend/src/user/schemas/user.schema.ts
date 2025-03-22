import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import * as mongoose from 'mongoose';
import { nanoid } from 'nanoid';
import { Balance } from 'src/balance/schemas/balance.schema';

export type UserDocument = mongoose.HydratedDocument<User>;

@Schema({
  toJSON: { getters: true },
  toObject: { getters: true },
})
export class User {
  @Prop({ unique: true })
  userId: string;

  @Prop({ required: true })
  email: string;
}

export const UserSchema = SchemaFactory.createForClass(User);

UserSchema.virtual('balances', {
  ref: Balance.name,
  localField: 'userId',
  foreignField: 'userId',
  getters: true,
});
