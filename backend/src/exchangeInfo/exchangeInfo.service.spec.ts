import { Test, TestingModule } from '@nestjs/testing';
import { ExchangeInfoService } from './exchangeInfo.service';

describe('ExchangeInfoService', () => {
  let service: ExchangeInfoService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [ExchangeInfoService],
    }).compile();

    service = module.get<ExchangeInfoService>(ExchangeInfoService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
