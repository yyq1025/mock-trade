import { Injectable } from '@nestjs/common';
import { WebsocketStream } from '@binance/connector-typescript';
import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import {
  ChangeStreamInsertDocument,
  ChangeStreamUpdateDocument,
} from 'mongodb';
import { Order, OrderDocument } from './schemas/order.schema';
import { CreateOrderDto } from './dto/create-order.dto';
import { PusherService } from 'src/pusher/pusher.service';

@Injectable()
export class OrderService {
  private wsClient: WebsocketStream;

  constructor(
    private readonly pusherService: PusherService,
    @InjectModel(Order.name) private orderModel: Model<Order>,
  ) {}

  onModuleInit() {
    this.orderModel
      .watch<
        OrderDocument,
        | ChangeStreamInsertDocument<OrderDocument>
        | ChangeStreamUpdateDocument<OrderDocument>
      >([{ $match: { operationType: { $in: ['insert', 'update'] } } }], { fullDocument: 'updateLookup' })
      .on('change', (change) => {
        const userId = change.fullDocument.user.toString();
        this.pusherService.trigger(userId, 'order', {
          operationType: change.operationType,
          order: change.fullDocument,
        });
      });
    this.wsClient = new WebsocketStream({
      callbacks: {
        open: () => console.debug('Connected to WebSocket server'),
        close: () => console.debug('Disconnected from WebSocket server'),
        message: (data) => {},
      },
      wsURL: process.env.BINANCE_WS_URL,
      combinedStreams: true,
    });
    this.wsClient.subscribe(['btcusdt@miniTicker', 'ethusdt@miniTicker']);
  }

  async createOrder(createOrderDto: CreateOrderDto): Promise<Order> {
    const createdOrder = new this.orderModel(createOrderDto);
    return await createdOrder.save();
  }
}
