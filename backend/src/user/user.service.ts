import { Injectable } from '@nestjs/common';
import { Model, Connection, Types } from 'mongoose';
import { InjectModel, InjectConnection } from '@nestjs/mongoose';
import { User } from './schemas/user.schema';
import { CreateUserDto } from './dto/create-user.dto';
import { Balance, BalanceChange } from 'src/balance/schemas/balance.schema';
import { GetUserDto } from './dto/get-user.dto';

@Injectable()
export class UserService {
  constructor(
    @InjectModel(User.name) private userModel: Model<User>,
    @InjectModel(Balance.name) private balanceModel: Model<Balance>,
    @InjectConnection() private readonly connection: Connection,
  ) {}

  async createUserWithInitBalance(createUserDto: CreateUserDto): Promise<void> {
    const session = await this.connection.startSession();
    session.startTransaction();
    try {
      const createdUser = new this.userModel(createUserDto);
      const user = await createdUser.save({ session });
      await this.balanceModel.updateOne(
        { userId: user.userId, asset: 'USDT' },
        {
          $addToSet: {
            balanceChanges: {
              orderId: user.userId,
              free: '1000000',
              locked: '0',
            },
          },
        },
        { upsert: true, session },
      );
      await session.commitTransaction();
    } catch (error) {
      await session.abortTransaction();
      throw error;
    } finally {
      session.endSession();
    }
  }

  async findUser(getUserDto: GetUserDto): Promise<User> {
    return this.userModel.findOne(getUserDto).populate('balances').exec();
  }
}
