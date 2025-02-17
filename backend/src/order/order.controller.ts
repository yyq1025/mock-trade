import { Body, Controller, Post, Delete } from '@nestjs/common';
import { OrderService } from './order.service';
import { CreateOrderDto } from './dto/create-order.dto';
import { CancelOrdersDto } from './dto/cancel-orders.dto';
import { CancelOrderDto } from './dto/cancel-order.dto';

@Controller('order')
export class OrderController {
  constructor(private readonly orderService: OrderService) {}

  @Post()
  createOrder(@Body() body: CreateOrderDto) {
    return this.orderService.createOrder(body);
  }

  @Delete()
  cancelOrder(@Body() body: CancelOrderDto) {
    return this.orderService.cancelOrder(body);
  }

  @Delete('/symbol')
  cancelOrders(@Body() body: CancelOrdersDto) {
    return this.orderService.cancelOrders(body);
  }
}
