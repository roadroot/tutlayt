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

class Author {
  final String id;
  final String name;
  final List<String>? books;
  final String? phone;

  const Author({
    required this.id,
    required this.name,
    this.books,
    this.phone,
  });

  factory Author.fromMap(Map<String, dynamic> data) {
    return Author(
      id: data['id'],
      name: data['name'],
      books: data['books']?.cast<String>(),
      phone: data['phone'],
    );
  }

  @override
  String toString() {
    StringBuffer output = StringBuffer();
    output.writeln('{');
    output.writeln(
        'id: "${id.replaceAll('\\', r'\\\\').replaceAll('\n', r'\\n').replaceAll('\r', r'\\r').replaceAll('\t', r'\\t').replaceAll('"', r'\\\"')}"');
    output.writeln(
        'name: "${name.replaceAll('\\', r'\\\\').replaceAll('\n', r'\\n').replaceAll('\r', r'\\r').replaceAll('\t', r'\\t').replaceAll('"', r'\\\"')}"');
    if (books != null) {
      output.writeln('books: [');
      output.writeln(books!.join(',\n'));
      output.writeln(']');
    }

    if (phone != null) {
      output.writeln(
          'phone: "${phone?.replaceAll('\\', r'\\\\').replaceAll('\n', r'\\n').replaceAll('\r', r'\\r').replaceAll('\t', r'\\t').replaceAll('"', r'\\\"')}"');
    }

    output.writeln('}');
    return output.toString();
  }
}

class AuthorSelector {
  final bool books;
  final bool phone;
  const AuthorSelector({
    this.books = false,
    this.phone = false,
  });
  @override
  String toString() {
    StringBuffer output = StringBuffer();
    output.writeln('{');
    output.writeln('id');
    output.writeln('name');
    if (books) {
      output.writeln('books');
    }
    if (phone) {
      output.writeln('phone');
    }
    output.writeln('}');
    return output.toString();
  }
}
