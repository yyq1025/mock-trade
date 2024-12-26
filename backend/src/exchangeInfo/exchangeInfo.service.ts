import { Injectable } from '@nestjs/common';
import {
  RestMarketTypes,
  Spot,
  SymbolStatus,
} from '@binance/connector-typescript';
import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { SymbolInfo, SymbolInfoDocument } from './schemas/symbolInfo.schema';

@Injectable()
export class ExchangeInfoService {
  private restClient: Spot;

  constructor(
    @InjectModel(SymbolInfo.name)
    private symbolInfoModel: Model<SymbolInfoDocument>,
  ) {}

  async onModuleInit() {
    this.restClient = new Spot('', '', {
      baseURL: process.env.BINANCE_REST_URL,
    });
    await this.syncExchangeInfo();
    setInterval(async () => await this.syncExchangeInfo(), 1000 * 60 * 60 * 24);
  }

  private async syncExchangeInfo(): Promise<void> {
    const options: RestMarketTypes.exchangeInformationOptions = {
      permissions: ['SPOT'],
      showPermissionSets: false,
      symbolStatus: SymbolStatus.TRADING,
    };

    try {
      const exchangeInfo = await this.restClient.exchangeInformation(options);
      await this.symbolInfoModel.bulkWrite(
        exchangeInfo.symbols.map((symbol) => ({
          updateOne: {
            filter: { symbol: symbol.symbol },
            update: {
              symbol: symbol.symbol,
              baseAsset: symbol.baseAsset,
              quoteAsset: symbol.quoteAsset,
            },
            upsert: true,
          },
        })),
      );
    } catch (error) {
      console.error(error);
    }
  }

  async getExchangeInfo(): Promise<SymbolInfo[]> {
    return this.symbolInfoModel.find().exec();
  }
}
