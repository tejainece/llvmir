part of llvmir;

class IrGlobalVarDecl implements ToIr, IrTopLevel {
  String name;

  IrType type;

  IrLinkage linkage = IrLinkage.private;

  IrGlobalVarDecl(this.name) {
    throw new UnimplementedError();
  }

  @override
  String toIr() {
    StringBuffer sb = new StringBuffer();
    sb.write('@$name = ${linkage.toIr()}');
    throw new UnimplementedError();
    // TODO
    return sb.toString();
  }
}

class ConstStringDecl implements ToIr, IrTopLevel {
  IrType get type => new IrArray(irI8, size);

  String name;

  String value;

  IrLinkage linkage = IrLinkage.private;

  int size;

  ConstStringDecl(this.name);

  ConstStringDecl setValue(String value) {
    this.value = value;
    this.size = value.length; // TODO
    return this;
  }

  @override
  String toIr() =>
      '@$name = ${linkage.toIr()} unnamed_addr constant ${type.toIr()} c"${value}"';
}