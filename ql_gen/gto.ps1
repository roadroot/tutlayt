#!/bin/bash

# Use this to get the test case output

$case = $args[0]

Write-Output "generating $case"

dart run bin/ql_gen.dart -s static/test/$case/input.gql -t static/test/$case/output.dart
