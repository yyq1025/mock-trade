import { Injectable } from '@nestjs/common';
import { Model, Connection, Types } from 'mongoose';
import { InjectModel, InjectConnection } from '@nestjs/mongoose';
import { User } from './schemas/user.schema';
import { CreateUserDto } from './dto/create-user.dto';
import { Balance } from 'src/balance/schemas/balance.schema';
import { GetUserDto } from './dto/get-user.dto';

@Injectable()
export class UserService {
  constructor(
    @InjectModel(User.name) private userModel: Model<User>,
    @InjectModel(Balance.name) private balanceModel: Model<Balance>,
    @InjectConnection() private readonly connection: Connection,
  ) {}

  async createUserInitBalance(createUserDto: CreateUserDto): Promise<User> {
    const session = await this.connection.startSession();
    session.startTransaction();
    try {
      const createdUser = new this.userModel(createUserDto);
      const user = await createdUser.save({ session });
      const balance = new this.balanceModel({
        userId: user.userId,
        asset: 'USDT',
        free: new Types.Decimal128('1000000'),
      });
      await balance.save({ session });
      await session.commitTransaction();
      return user;
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
