import Decimal from 'decimal.js';
import { Types } from 'mongoose';

export const decimal128Add = (
  a: Types.Decimal128,
  b: Types.Decimal128,
): Types.Decimal128 => {
  return new Types.Decimal128(
    Decimal.add(a.toString(), b.toString()).toString(),
  );
};

export const decimal128Sub = (
  a: Types.Decimal128,
  b: Types.Decimal128,
): Types.Decimal128 => {
  return new Types.Decimal128(
    Decimal.sub(a.toString(), b.toString()).toString(),
  );
};

export const decimal128Mul = (
  a: Types.Decimal128,
  b: Types.Decimal128,
): Types.Decimal128 => {
  return new Types.Decimal128(
    Decimal.mul(a.toString(), b.toString()).toString(),
  );
};

export const decimal128Neg = (a: Types.Decimal128): Types.Decimal128 => {
  return new Types.Decimal128(Decimal.mul('-1', a.toString()).toString());
};
