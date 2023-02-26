class VariableType {
  const VariableType({
    required this.name,
    required this.isList,
    required this.isNullable,
    required this.isObject,
  });

  final String name;
  final bool isList;
  final bool isNullable;

  /// If the type is a non dart core type or a list of non dart core type
  final bool isObject;

  get isString => name == 'String';

  @override
  String toString() {
    return 'type[$name] isString[$isString] isList[$isList] isNullable[$isNullable] isObject[$isObject]';
  }

  String toResultName(
      {bool withList = false,
      bool withNullability = false,
      bool withRequired = false}) {
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
}
