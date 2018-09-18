part of llvmir;

class IrLiteralI8 implements ToIr, IrRhsExpression, IrIntData {
  final IrType type = irI8;

  int value;

  IrLiteralI8(this.value);

  @override
  String toIr() => '${type.toIr()} $value';

  @override
  String toIrData() => value.toString();
}

IrLiteralI8 irLiteralI8(int value) => new IrLiteralI8(value);

class IrLiteralI32 implements ToIr, IrRhsExpression, IrIntData {
  final IrType type = irI32;

  int value;

  IrLiteralI32(this.value);

  @override
  String toIr() => '${type.toIr()} $value';

  @override
  String toIrData() => value.toString();
}

IrLiteralI32 irLiteralI32(int value) => new IrLiteralI32(value);