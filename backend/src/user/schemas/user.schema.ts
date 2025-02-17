import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import * as mongoose from 'mongoose';
import { nanoid } from 'nanoid';
import { Balance } from 'src/balance/schemas/balance.schema';

export type UserDocument = mongoose.HydratedDocument<User>;

@Schema({
  toJSON: { virtuals: ['balances'] },
  toObject: { virtuals: ['balances'] },
})
export class User {
  @Prop({ unique: true, default: () => nanoid() })
  userId: string;

  @Prop({ required: true, unique: true })
  email: string;
}

export const UserSchema = SchemaFactory.createForClass(User);

UserSchema.virtual('balances', {
  ref: Balance.name,
  localField: 'userId',
  foreignField: 'userId',
});
