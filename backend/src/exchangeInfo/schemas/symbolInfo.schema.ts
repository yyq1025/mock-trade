import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import * as mongoose from 'mongoose';

export type SymbolInfoDocument = mongoose.HydratedDocument<SymbolInfo>;

@Schema()
export class SymbolInfo {
  @Prop({ unique: true })
  symbol: string;

  @Prop()
  baseAsset: string;

  @Prop()
  quoteAsset: string;
}

export const SymbolInfoSchema = SchemaFactory.createForClass(SymbolInfo);
