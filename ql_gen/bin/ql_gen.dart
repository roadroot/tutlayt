import 'dart:io';

import 'package:args/args.dart';
import 'package:ql_gen/ql_gen.dart';

const source = 'source';
const target = 'target';
const help = 'help';

void main(List<String> arguments) {
  // print current working directory
  print(Directory.current.path);
  final parser = ArgParser()
    ..addOption(source,
        abbr: 's', defaultsTo: 'schema.gql', help: 'The source file')
    ..addOption(target,
        abbr: 't', defaultsTo: 'ql.dart', help: 'The target file')
    ..addFlag(help,
        abbr: 'h', negatable: false, help: 'Prints this help message');
  final results = parser.parse(arguments);
  if (!checks(parser, results)) return;
  ApiGenerator(results[source]).export(results[target]);
}

bool checks(ArgParser parser, ArgResults results) {
  if (results[help]) {
    print(parser.usage);
    return false;
  }

  if (!File(results[source]).existsSync()) {
    print('Source file \'${results[source]}\' does not exist');
    return false;
  }
  return true;
}
