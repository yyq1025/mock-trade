import { Controller, Get } from '@nestjs/common';
import { ExchangeInfoService } from './exchangeInfo.service';

@Controller('exchangeInfo')
export class ExchangeInfoController {
  constructor(private readonly exchangeService: ExchangeInfoService) {}

  @Get()
  async getExchangeInfo() {
    return await this.exchangeService.getExchangeInfo();
  }
}
