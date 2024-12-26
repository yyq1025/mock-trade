export class CreateOrderDto {
  user: string;
  symbol: string;
  orderType: string;
  side: string;
  quantity: number;
  price: number;
}
