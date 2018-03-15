/// Based on the tutorial found [here](http://releases.llvm.org/2.6/docs/tutorial/JITTutorial1.html).
library llvm.example;

import 'package:llvmir/llvmir.dart';

main() {
  print(new IrModule([
    new IrGlobalStringConstantDecl('msg').setValue('Hello world!'),
    new IrFuncDeclr('puts').setReturn(irI32).addArg(new IrDeclareArg(irI8Ptr)),
    new IrFunc('main')
        .setReturn(irI32)
        .addAssignStatement(
            '%1',
            new IrGetElementPtr(
                new IrArray(irI8, 12),
                new IrVar('@msg', new IrPointerType(new IrArray(irI8, 12))),
                [irConstantI8(0), irConstantI8(0)]))
        .addStatement(new IrCall('@puts', irI32, [new IrVar('%1', irI8Ptr)]))
        .addStatement(irRet(irConstantI32(42)))
  ]).toIr());
}
