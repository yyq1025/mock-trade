import { Injectable } from '@nestjs/common';
import * as Pusher from 'pusher';

@Injectable()
export class PusherService {
  private pusher: Pusher;

  onModuleInit() {
    this.pusher = new Pusher({
      appId: process.env.PUSHER_APP_ID,
      key: process.env.PUSHER_KEY,
      secret: process.env.PUSHER_SECRET,
      cluster: process.env.PUSHER_CLUSTER,
    });
  }

  getPusher() {
    return this.pusher;
  }
}
