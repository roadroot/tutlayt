enum NativeType {
  string(
    qlName: 'String',
    dartName: 'String',
  ),
  int(
    qlName: 'Int',
    dartName: 'int',
  ),
  double(
    qlName: 'Float',
    dartName: 'double',
  ),
  boolean(
    qlName: 'Boolean',
    dartName: 'bool',
  ),
  id(
    qlName: 'ID',
    dartName: 'String',
  ),
  upload(
      qlName: 'Upload',
      dartName: 'MultipartFile',
      dartImport: 'package:http/http.dart',
      isVariable: true),
  dateTime(
    qlName: 'DateTime',
    dartName: 'DateTime',
    parseFunction: 'DateTime.parse',
  );

  final String qlName;
  final String? dartName;
  final String? dartImport;
  final String? parseFunction;
  final bool isVariable;

  const NativeType({
    required this.qlName,
    this.dartName,
    // ignore: unused_element
    this.dartImport,
    this.parseFunction,
    this.isVariable = false,
  });
}
