part of llvmir;

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