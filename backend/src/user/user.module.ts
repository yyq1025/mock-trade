import { Module } from '@nestjs/common';
import { UserService } from './user.service';
import { UserController } from './user.controller';
import { MongooseModule } from '@nestjs/mongoose';
import { User, UserSchema } from './schemas/user.schema';
import {
  Balance,
  BalanceChange,
  BalanceChangeSchema,
  BalanceSchema,
} from 'src/balance/schemas/balance.schema';
import { FirebaseModule } from 'src/firebase/firebase.module';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: User.name, schema: UserSchema },
      { name: Balance.name, schema: BalanceSchema },
      { name: BalanceChange.name, schema: BalanceChangeSchema },
    ]),
    FirebaseModule,
  ],
  providers: [UserService],
  controllers: [UserController],
})
export class UserModule {}
