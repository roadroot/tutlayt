#!/bin/bash
echo "generating $1"

echo "dart run bin/ql_gen.dart -s static/test/$1/input.gql -t static/test/$1/output.dart"
eval dart run bin/ql_gen.dart -s static/test/$1/input.gql -t static/test/$1/output.dart
