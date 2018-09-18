part of llvmir;

class IrConstI8Decl implements ToIr, IrTopLevel {
  final IrType type = irI8;

  String name;

  int value;

  IrLinkage linkage = IrLinkage.private;

  IrConstI8Decl(this.name, [this.value]);

  IrConstI8Decl setValue(int value) {
    this.value = value;
    return this;
  }

  @override
  String toIr() {
    StringBuffer sb = new StringBuffer();
    sb.write('@$name =');
    if(linkage != IrLinkage.private) {
      sb.write(' ${linkage.toIr()}');
    }
    sb.write(' constant ${type.toIr()} $value');
    return sb.toString();
  }
}

class IrI8Decl implements ToIr, IrTopLevel {
  final IrType type = irI8;

  String name;

  int value;

  IrLinkage linkage = IrLinkage.private;

  IrI8Decl(this.name, [this.value]);

  IrI8Decl setValue(int value) {
    this.value = value;
    return this;
  }

  @override
  String toIr() {
    StringBuffer sb = new StringBuffer();
    sb.write('@$name =');
    if(linkage != IrLinkage.private) {
      sb.write(' ${linkage.toIr()}');
    }
    sb.write(' ${type.toIr()} $value');
    return sb.toString();
  }
}