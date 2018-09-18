library llvmir;

part 'src/type.dart';
part 'global_var/int.dart';
part 'global_var/string.dart';
part 'global_var/global_var.dart';
part 'literals/literals.dart';

abstract class ToIr {
  String toIr();
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

/// Top level construct
abstract class IrTopLevel implements ToIr {}

class IrArg implements ToIr {
  IrType type;

  String name;

  IrArg(this.name, this.type);

  String toIr() {
    StringBuffer sb = new StringBuffer();
    sb.write(type.toIr());
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

abstract class IrIntVar implements IrVarBase, IrIntData {}

class IrVarI8 implements ToIr, IrRhsExpression, IrIntVar {
  final IrType type = irI8;

  String name;

  IrVarI8(this.name);

  @override
  String toIr() => '${type.toIr()} $name';

  @override
  String toIrData() => name;
}

class IrVarI32 implements ToIr, IrRhsExpression, IrIntVar {
  final IrType type = irI32;

  String name;

  @override
  String toIr() => '${type.toIr()} $name';

  @override
  String toIrData() => name;
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

abstract class IrIntData implements ToIr, IrData {
  String toIrData();
}

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

class IrAlloca implements IrRhsExpression, ToIr {
  IrType type;

  IrIntData numElements;

  // TODO align

  // TODO addrspace

  IrAlloca(this.type, [this.numElements]);

  @override
  String toIr() {
    StringBuffer sb = new StringBuffer();
    sb.write('alloca ${type.toIr()}');
    if (numElements != null) {
      sb.write(',  ${numElements.toIr()}');
    }
    return sb.toString();
  }
}

class IrStore implements IrStatement, ToIr {
  IrVar dst;

  IrData src;

  // TODO volatile

  // TODO atomic

  // TODO align

  // TODO metadata

  IrStore(this.dst, this.src);

  @override
  String toIr() {
    StringBuffer sb = new StringBuffer();
    sb.write('store ${src.toIr()}, ${dst.toIr()}');
    return sb.toString();
  }
}

class IrLoad implements IrRhsExpression, ToIr {
  IrType type;

  IrVar dst;

  // TODO align

  // TODO volatile

  // TODO metadata

  IrLoad(this.type, this.dst);

  @override
  String toIr() {
    StringBuffer sb = new StringBuffer();
    sb.write('load ${type.toIr()}, ${dst.toIr()}');
    return sb.toString();
  }
}

class IrAdd implements IrRhsExpression, ToIr {
  IrIntType type;

  IrIntData op1;

  IrIntData op2;

  // TODO num

  // TODO nsw

  IrAdd(this.type, this.op1, this.op2);

  @override
  String toIr() {
    StringBuffer sb = new StringBuffer();
    sb.write('add ${type.toIr()} ${op1.toIrData()}, ${op2.toIrData()}');
    return sb.toString();
  }
}