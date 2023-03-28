import 'dart:io';

class Visitor {
  // void visit(String path) async {
  //   String schema = await readSchema(path);
  // }

  static Future<String> readSchema(String path) async {
    final file = File(path);
    return String.fromCharCodes((await (file
        .openRead()
        .reduce((previous, element) => previous + element))));
  }
}
