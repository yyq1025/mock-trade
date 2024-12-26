import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { ExchangeInfoService } from './exchangeInfo.service';
import { SymbolInfo, SymbolInfoSchema } from './schemas/symbolInfo.schema';
import { ExchangeInfoController } from './exchangeInfo.controller';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: SymbolInfo.name, schema: SymbolInfoSchema },
    ]),
  ],
  providers: [ExchangeInfoService],
  controllers: [ExchangeInfoController],
})
export class ExchangeInfoModule {}
