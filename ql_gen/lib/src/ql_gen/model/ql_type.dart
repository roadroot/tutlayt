import 'native_type.dart';

class QlType {
  late String? name;
  final bool isNullable;
  final bool isList;
  final QlType? innerType;
  final NativeType? nativeType;

  QlType({
    String? name,
    required this.isNullable,
    required this.isList,
    this.innerType,
  })  : nativeType = NativeType.values
            .where((element) => element.qlName == name)
            .firstOrNull,
        assert(
          isList == (innerType != null) && (isList == (name == null)),
          isList
              ? 'When having a list, the name must be null and the innerType must be not null'
              : 'When not having a list, the name must be not null and the innerType must be null',
        ) {
    this.name = nativeType?.dartName ?? name;
  }

  /// returns whether the type should be handled as a variable.
  ///
  /// e.g. `List<List<String>>` should not be handled as a variable (`false`).
  /// `List<Upload>` should be handled as a variable (`true`).
  bool get isVariable => coreType.nativeType?.isVariable ?? false;

  // TODO: is ID well handled? Should it be quoted? What if we use a number as an ID?
  /// Checks if the type is `String`.
  ///
  /// ID, String are strings.
  /// List<String>, DateTime are not strings.
  bool get isString => name == NativeType.string.dartName;

  /// Returns the dart type of the selector.
  ///
  /// For example, for `List<List<String>>`, the selector type is `bool`.
  ///
  /// For `List<List<CustomType>>`, the selector type is `CustomTypeSelector`.
  String get selectorName => isList
      ? innerType!.selectorName
      : hasNativeType
          ? 'bool'
          : '${name}Selector';

  ///Return `'?'` if the type is nullable, `''` otherwise.
  String get nullable => isNullable ? '?' : '';

  /// Returns whether the type is a (list of)* native type.
  ///
  /// For example, `List<List<String>>`, `Int`, `DateTime` are (`true`).
  /// `List<List<CustomType>>`, `CustomType` are not (`false`).
  bool get hasNativeType => NativeType.values.any((e) => e.dartName == name);

  /// Returns whether the type is (list of)* native type.
  ///
  /// For example, `List<List<String>>`, `Int`, `DateTime` are (`true`).
  /// `List<List<CustomType>>`, `CustomType` are not (`false`).
  bool get hasNativeCore => coreType.hasNativeType;

  /// Returns the core type of the type.
  ///
  /// For example, for `List<List<String>>`, the core type is `String`.
  /// For `List<List<CustomType>>`, the core type is `CustomType`.
  QlType get coreType => isList ? innerType!.coreType : this;

  @override
  String toString() {
    StringBuffer output = StringBuffer();
    if (isList) {
      output.write('List<$innerType>');
      output.write(isNullable ? '?' : '');
    } else {
      output.write(nativeType?.dartName ?? name);
      output.write(isNullable ? '?' : '');
    }
    return output.toString();
  }
}
