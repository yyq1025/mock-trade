import { Body, Controller, Get, Post, UseGuards, Req } from '@nestjs/common';
import { UserService } from './user.service';
import { FirebaseAuthGuard } from 'src/firebase-auth/firebase-auth.guard';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post()
  @UseGuards(FirebaseAuthGuard)
  async createUser(@Req() req: any) {
    const { email, uid: userId } = req.user;
    return this.userService.createUserWithInitBalance({ email, userId });
  }

  @Get()
  @UseGuards(FirebaseAuthGuard)
  async findUser(@Req() req: any) {
    const { uid: userId } = req.user;
    return this.userService.findUser({ userId });
  }
}
