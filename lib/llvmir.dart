library llvmir;

part 'src/type.dart';

abstract class ToIr {
  String toIr();
}

/// Top level construct
abstract class IrTopLevel implements ToIr {}

class IrArg implements ToIr {
  IrType type;

  String name;

  IrArg(this.name, this.type);

  String toIr() {
    StringBuffer sb = new StringBuffer();
    sb.write(type.toIr());
    sb.write(' ');
    sb.write(name);
    return sb.toString();
  }
}

IrArg irI8Arg(String name) => new IrArg(name, irI8);

class IrFunc implements ToIr, IrTopLevel {
  String name;

  IrType returns;

  List<IrArg> args = <IrArg>[];

  List<IrStatement> statements = <IrStatement>[];

  IrFunc(this.name);

  IrFunc setReturn(IrType type) {
    returns = type;
    return this;
  }

  IrFunc addArg(IrArg arg) {
    args.add(arg);
    return this;
  }

  IrFunc addStatement(IrStatement st) {
    statements.add(st);
    return this;
  }

  IrFunc addAssignStatement(String name, IrRhsExpression expression) {
    statements.add(new IrAssign(name, expression));
    return this;
  }

  @override
  String toIr() {
    StringBuffer sb = new StringBuffer();
    sb.write('define ${returns.toIr()} @$name(');
    sb.write(args.map((a) => a.toIr()).join(', '));
    sb.writeln(') {');
    statements.map((s) => s.toIr()).forEach(sb.writeln);
    sb.write('}');
    return sb.toString();
  }
}

abstract class IrStatement implements ToIr {}

abstract class IrRhsExpression implements ToIr, IrStatement {}

class IrRet implements IrStatement, ToIr {
  IrRhsExpression expression;

  IrRet(this.expression);

  @override
  String toIr() => 'ret ${expression.toIr()}';
}

IrRet irRet(IrRhsExpression expression) => new IrRet(expression);

abstract class IrVarBase implements ToIr, IrRhsExpression, IrData {
  IrType get type;

  String get name;
}

class IrVar implements IrVarBase, ToIr, IrRhsExpression {
  IrType type;

  String name;

  IrVar(this.name, this.type);

  @override
  String toIr() => '${type.toIr()} $name';
}

class IrVarI8 implements IrVarBase, ToIr, IrRhsExpression, IrIntData {
  final IrType type = irI8;

  String name;

  @override
  String toIr() => '${type.toIr()} $name';
}

class IrVarI32 implements IrVarBase, ToIr, IrRhsExpression, IrIntData {
  final IrType type = irI32;

  String name;

  @override
  String toIr() => '${type.toIr()} $name';
}

class IrFuncDeclr implements ToIr, IrTopLevel {
  String name;

  IrType returns;

  List<IrDeclareArg> args = <IrDeclareArg>[];

  IrFuncDeclr(this.name);

  IrFuncDeclr setReturn(IrType type) {
    returns = type;
    return this;
  }

  IrFuncDeclr addArg(IrDeclareArg arg) {
    args.add(arg);
    return this;
  }

  @override
  String toIr() {
    StringBuffer sb = new StringBuffer();
    sb.write('declare ${returns.toIr()} @$name(');
    sb.write(args.map((a) => a.toIr()).join(', '));
    sb.write(')');
    return sb.toString();
  }
}

class IrDeclareArg implements ToIr {
  IrType type;

  IrDeclareArg(this.type);

  String toIr() {
    StringBuffer sb = new StringBuffer();
    sb.write(type.toIr());
    return sb.toString();
  }
}

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

class IrGlobalStringConstantDecl implements ToIr, IrTopLevel {
  String name;

  String value;

  IrLinkage linkage = IrLinkage.private;

  int size;

  IrGlobalStringConstantDecl(this.name);

  IrGlobalStringConstantDecl setValue(String value) {
    this.value = value;
    this.size = value.length; // TODO
    return this;
  }

  @override
  String toIr() =>
      '@$name = ${linkage.toIr()} unnamed_addr constant [$size x i8] c"${value}"';
}

class IrLinkage implements ToIr {
  final String representation;

  const IrLinkage._(this.representation);

  @override
  String toIr() => representation;

  static const IrLinkage private = const IrLinkage._('private');

  static const IrLinkage internal = const IrLinkage._('internal');

  static const IrLinkage availableExternally =
      const IrLinkage._('available_externally');

  static const IrLinkage linkonce = const IrLinkage._('linkonce');

  static const IrLinkage weak = const IrLinkage._('weak');

  static const IrLinkage common = const IrLinkage._('common');

  static const IrLinkage appending = const IrLinkage._('appending');

  static const IrLinkage externWeak = const IrLinkage._('extern_weak');

  static const IrLinkage linkonceOdr = const IrLinkage._('linkonce_odr');

  static const IrLinkage weakOdr = const IrLinkage._('weak_odr');

  static const IrLinkage external = const IrLinkage._('external');
}

class IrGetElementPtr implements ToIr, IrRhsExpression {
  IrType type;

  IrVarBase variable;

  List<IrIntData> indexes = <IrIntData>[];

  IrGetElementPtr(this.type, this.variable, this.indexes);

  @override
  String toIr() {
    StringBuffer sb = new StringBuffer();
    sb.write('getelementptr ${type.toIr()}, ${variable.toIr()}, ');
    sb.write(indexes.map((i) => i.toIr()).join(', '));
    return sb.toString();
  }
}

abstract class IrData implements ToIr {
  IrType get type;
}

abstract class IrIntData implements ToIr, IrData {}

class IrConstantI8 implements ToIr, IrRhsExpression, IrIntData {
  final IrType type = irI8;

  int value;

  IrConstantI8(this.value);

  @override
  String toIr() => '${type.toIr()} $value';
}

IrConstantI8 irConstantI8(int value) => new IrConstantI8(value);

class IrConstantI32 implements ToIr, IrRhsExpression, IrIntData {
  final IrType type = irI32;

  int value;

  IrConstantI32(this.value);

  @override
  String toIr() => '${type.toIr()} $value';
}

IrConstantI32 irConstantI32(int value) => new IrConstantI32(value);

class IrAssign implements IrStatement, ToIr {
  String name;

  IrRhsExpression expression;

  IrAssign(this.name, this.expression);

  @override
  String toIr() => '$name = ${expression.toIr()}';
}

class IrCall implements IrStatement, IrRhsExpression, ToIr {
  IrType returnType;

  String name;

  List<IrData> args = <IrData>[];

  IrCall(this.name, this.returnType, [this.args]) {
    args ??= <IrData>[];
  }

  @override
  String toIr() {
    StringBuffer sb = new StringBuffer();
    sb.write('call ${returnType.toIr()} $name(');
    sb.write(args.map((a) => a.toIr()).join(', '));
    sb.write(')');
    return sb.toString();
  }
}

class IrModule implements ToIr, IrTopLevel {
  List<IrTopLevel> constructs = <IrTopLevel>[];

  IrModule(this.constructs);

  IrModule add(IrTopLevel construct) {
    constructs.add(construct);
    return this;
  }

  @override
  String toIr() => constructs.map((c) => c.toIr()).join('\n\n');
}
