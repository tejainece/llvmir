/// Based on the tutorial found [here](http://releases.llvm.org/2.6/docs/tutorial/JITTutorial1.html).
library llvm.example;

import 'package:llvmir/llvmir.dart';

main() {
  print(new IrModule([
    new IrConstI8Decl('five').setValue(5),
    new IrFunc('plusFive')
        .addArg(irI8Arg('%1'))
        .setReturn(irI8)
        .addAssignStatement('%1', new IrAlloca(irI8))
        .addAssignStatement(
            '%1', new IrAdd(irI8, new IrVarI8('%1'), irLiteralI8(5)))
        .addAssignStatement('%2', new IrLoad(irI8, new IrVar('%1', irI8Ptr)))
        .addStatement(new IrStore(new IrVar('%1', irI8Ptr), irLiteralI8(5))),
    new ConstStringDecl('msg').setValue('Hello world!'),
    new IrFuncDeclr('puts').setReturn(irI32).addArg(new IrDeclareArg(irI8Ptr)),
    new IrFunc('main')
        .setReturn(irI32)
        .addAssignStatement(
            '%1',
            new IrGetElementPtr(
                new IrArray(irI8, 12),
                new IrVar('@msg', new IrPointerType(new IrArray(irI8, 12))),
                [irLiteralI8(0), irLiteralI8(0)]))
        .addStatement(new IrCall('@puts', irI32, [new IrVar('%1', irI8Ptr)]))
        .addStatement(irRet(irLiteralI32(42)))
  ]).toIr());
}
