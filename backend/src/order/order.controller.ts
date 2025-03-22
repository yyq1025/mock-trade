import {
  Body,
  Controller,
  Post,
  Delete,
  UseGuards,
  Req,
  Get,
} from '@nestjs/common';
import { OrderService } from './order.service';
import { CreateOrderDto } from './dto/create-order.dto';
import { CancelOrdersDto } from './dto/cancel-orders.dto';
import { CancelOrderDto } from './dto/cancel-order.dto';
import { FirebaseAuthGuard } from 'src/firebase-auth/firebase-auth.guard';

@Controller('order')
export class OrderController {
  constructor(private readonly orderService: OrderService) {}

  @Post()
  @UseGuards(FirebaseAuthGuard)
  async createOrder(@Req() req: any, @Body() body: CreateOrderDto) {
    const { uid: userId } = req.user;
    return this.orderService.createOrder({ ...body, userId });
  }

  @Get('/openOrders')
  @UseGuards(FirebaseAuthGuard)
  async getOpenOrders(@Req() req: any) {
    const { uid: userId } = req.user;
    return this.orderService.getOpenOrders({ userId });
  }

  @Get('/tradeHistory')
  @UseGuards(FirebaseAuthGuard)
  async getTradeHistory(@Req() req: any) {
    const { uid: userId } = req.user;
    return this.orderService.getTradeHistory({ userId });
  }

  @Delete()
  @UseGuards(FirebaseAuthGuard)
  async cancelOrder(@Req() req: any, @Body() body: CancelOrderDto) {
    const { uid: userId } = req.user;
    return this.orderService.cancelOrder({ ...body, userId });
  }
}
