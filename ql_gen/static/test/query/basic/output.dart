// GENERATED CODE - DO NOT MODIFY BY HAND
dynamic construct(dynamic data,
    {dynamic Function(Map<String, dynamic>)? fromMap}) {
  if (data == null) {
    return null;
  }
  if (data is List) {
    return data.map((e) => construct(e, fromMap: fromMap)).toList();
  }
  if (fromMap != null) {
    return fromMap(data);
  }
  return data;
}

class Query {
  final Future<Map<String, dynamic>?> Function(String query) _executor;

  const Query(this._executor);

  Future<String?> hello() async {
    return construct(
      (await _executor(helloQl()))?['hello'],
    );
  }

  String helloQl() {
    StringBuffer output = StringBuffer();
    output.writeln('query {');
    output.writeln('hello');
    output.writeln('}');
    return output.toString();
  }

  @override
  String toString() {
    StringBuffer output = StringBuffer();
    output.writeln('{');
    output.writeln('}');
    return output.toString();
  }
}
