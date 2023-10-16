class QlType {
  final String? name;
  final bool isNullable;
  final bool isList;
  final QlType? innerType;

  static const Map<String, String> _typeMap = {
    'String': 'String',
    'Int': 'int',
    'Float': 'double',
    'Boolean': 'bool',
    'ID': 'String',
    'Upload': 'File',
  };

  bool get isString => name == 'String';
  bool get isUploadType => name == 'File' || isList && innerType!.isUploadType;

  String get selectorName => isList
      ? innerType!.selectorName
      : isBasicType
          ? 'bool'
          : '${name}Selector';

  String get input => isList
      ? 'List<${innerType!.input}>'
      : isBasicType
          ? name!
          : '${name}Input';

  String _getInput({bool withNullable = false}) {
    StringBuffer output = StringBuffer();
    output.write(
      isList
          ? 'List<${innerType!._getInput(withNullable: withNullable)}>'
          : isBasicType
              ? name!
              : '${name}Input',
    );
    if (withNullable && isNullable) {
      output.write('?');
    }
    return output.toString();
  }

  String get inputWithNullable => _getInput(withNullable: true);
  String get inputWithoutNullable => _getInput(withNullable: false);

  bool get isBasicType => _typeMap.containsValue(name);
  bool get isBasicTypeOrBasicList =>
      isBasicType || (isList && innerType!.isBasicTypeOrBasicList);
  QlType get coreType => isList ? innerType!.coreType : this;

  static String? _convertType(String? type) =>
      type == null ? null : _typeMap[type] ?? type;

  QlType({
    String? name,
    required this.isNullable,
    required this.isList,
    this.innerType,
  })  : name = _convertType(name),
        assert(
          isList == (innerType != null) && (isList == (name == null)),
          isList
              ? 'When having a list, the name must be null and the innerType must be not null'
              : 'When not having a list, the name must be not null and the innerType must be null',
        );

  @override
  String toString() {
    StringBuffer output = StringBuffer();
    if (isList) {
      output.write('List<$innerType>');
      output.write(isNullable ? '?' : '');
    } else {
      output.write(name);
      output.write(isNullable ? '?' : '');
    }
    return output.toString();
  }
}
