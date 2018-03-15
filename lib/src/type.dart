part of llvmir;

abstract class IrType implements ToIr {}

class IrPointerType implements ToIr, IrType {
  IrType type;

  IrPointerType(this.type);

  @override
  String toIr() => '${type.toIr()}*';
}

class IrI8 implements ToIr, IrType {
  const IrI8();

  @override
  String toIr() => 'i8';
}

const IrI8 irI8 = const IrI8();

final IrPointerType irI8Ptr = new IrPointerType(irI8);

class IrI32 implements ToIr, IrType {
  const IrI32();

  @override
  String toIr() => 'i32';
}

const IrI32 irI32 = const IrI32();

class IrArray implements ToIr, IrType {
  IrType type;

  int size;

  IrArray(this.type, this.size);

  @override
  String toIr() => '[$size x ${type.toIr()}]';
}