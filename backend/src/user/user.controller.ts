import { Body, Controller, Get, Post } from '@nestjs/common';
import { UserService } from './user.service';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post()
  createUser(@Body() body: any) {
    return this.userService.createUserInitBalance(body);
  }

  @Get()
  findUser(@Body() body: any) {
    return this.userService.findUser(body);
  }
}
