import 'dart:io';

void main(List<String> args) async {
  Visitor().visit('schema.gql');
}

class Visitor {
  static const String IDENTIFIER_PATTERN = r'\w[\w\d]*';
  static const String TYPE_PATTERN = r'type\s+.+\{.*\}';

  void visit(String path) async {
    String schema = await _readSchema(path);
    RegExp(TYPE_PATTERN, multiLine: true).allMatches(schema).forEach((match) {
      print(match.group(0));
    });
  }

  static Future<String> _readSchema(String path) async {
    final file = File(path);
    return String.fromCharCodes((await (file
        .openRead()
        .reduce((previous, element) => previous + element))));
  }
}
