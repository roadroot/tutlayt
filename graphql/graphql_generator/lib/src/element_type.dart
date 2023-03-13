import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';

class VariableType {
  const VariableType(this._dartType);

  final DartType _dartType;

  /// If the type is a non dart core type or a list of non dart core type
  bool get isObject => _isObject(_getListType(_dartType));
  bool get isList => _dartType.isDartCoreList;
  bool get isNullable =>
      _dartType.nullabilitySuffix == NullabilitySuffix.question;
  String get name => _getListType(_dartType).element!.name!;
  List<VariableType> get genericTypes => _getGenericTypes(_dartType);
  bool get isString => name == 'String';

  @override
  String toString() {
    return 'type[$name] isString[$isString] isList[$isList] isNullable[$isNullable] isObject[$isObject]';
  }

  String toResultName({
    bool withList = false,
    bool withNullability = false,
    bool withRequired = false,
  }) {
    if (!isNullable && withRequired) {
      return 'required ${toResultName(withList: withList)}';
    }
    if (isNullable && withNullability) {
      return '${toResultName(withList: withList)}?';
    }
    if (isList && withList) {
      return 'List<${toResultName()}>';
    }
    if (isObject) {
      return '${name}Result';
    }
    return name;
  }

  get isDynamic => name == 'dynamic';
  get isVoid => name == 'void';
  get isExplicit => !isDynamic && !isVoid;

  String toQlClassName({bool withList = false, bool withNullability = false}) {
    if (isNullable && withNullability) {
      return '${toQlClassName(withList: withList)}?';
    }
    if (isList && withList) {
      return 'List<${toQlClassName()}>';
    }
    if (isObject) {
      return '${name}Ql';
    }
    return name;
  }

  get nameWithNullability {
    if (isNullable) {
      return '$name?';
    }
    return name;
  }

  /// Checks if the [type] is a non dart core object
  static bool _isObject(DartType type) {
    return !(type.isBottom ||
        type.isDartCoreBool ||
        type.isDartCoreDouble ||
        type.isDartCoreInt ||
        type.isDartCoreList ||
        type.isDartCoreMap ||
        type.isDartCoreNum ||
        type.isDartCoreObject ||
        type.isDartCoreSet ||
        type.isDartCoreString ||
        type.isDartCoreSymbol ||
        type.isDynamic ||
        type.isVoid);
  }

  static DartType _getListType(DartType type) {
    if (type is ParameterizedType && type.isDartCoreList) {
      return type.typeArguments.first;
    }
    return type;
  }

  static List<VariableType> _getGenericTypes(DartType type) {
    if (type is ParameterizedType) {
      return type.typeArguments.map((e) => VariableType(e)).toList();
    }
    return [];
  }
}
