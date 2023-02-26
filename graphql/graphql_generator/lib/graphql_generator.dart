import 'package:build/build.dart';
import 'package:graphql_generator/src/graphql_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder graphqlGenerator(BuilderOptions options) =>
    SharedPartBuilder([GraphQLGenerator()], 'graphql_api');
