import { Test, TestingModule } from '@nestjs/testing';
import { ExchangeInfoController } from './exchangeInfo.controller';

describe('ExchangeInfoController', () => {
  let controller: ExchangeInfoController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [ExchangeInfoController],
    }).compile();

    controller = module.get<ExchangeInfoController>(ExchangeInfoController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
