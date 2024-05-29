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
  final List<Author>? books;
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
      books: construct(data['books'], fromMap: Author.fromMap)?.cast<Author>(),
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
  final bool phone;
  final AuthorSelector? books;
  const AuthorSelector({
    this.phone = false,
    this.books,
  });
  @override
  String toString() {
    StringBuffer output = StringBuffer();
    output.writeln('{');
    output.writeln('id');
    output.writeln('name');
    if (phone) {
      output.writeln('phone');
    }
    if (books != null) {
      output.writeln('books ${books!}');
    }
    output.writeln('}');
    return output.toString();
  }
}

class Book {
  final String id;
  final String title;
  final Author author;
  final Author? coAuthor;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    this.coAuthor,
  });

  factory Book.fromMap(Map<String, dynamic> data) {
    return Book(
      id: data['id'],
      title: data['title'],
      author: Author.fromMap(data['author']),
      coAuthor:
          data['coAuthor'] == null ? null : Author.fromMap(data['coAuthor']),
    );
  }

  @override
  String toString() {
    StringBuffer output = StringBuffer();
    output.writeln('{');
    output.writeln(
        'id: "${id.replaceAll('\\', r'\\\\').replaceAll('\n', r'\\n').replaceAll('\r', r'\\r').replaceAll('\t', r'\\t').replaceAll('"', r'\\\"')}"');
    output.writeln(
        'title: "${title.replaceAll('\\', r'\\\\').replaceAll('\n', r'\\n').replaceAll('\r', r'\\r').replaceAll('\t', r'\\t').replaceAll('"', r'\\\"')}"');
    output.writeln('author: $author');

    if (coAuthor != null) {
      output.writeln('coAuthor: $coAuthor');
    }

    output.writeln('}');
    return output.toString();
  }
}

class BookSelector {
  final AuthorSelector author;
  final AuthorSelector? coAuthor;
  const BookSelector({
    this.author = const AuthorSelector(),
    this.coAuthor,
  });
  @override
  String toString() {
    StringBuffer output = StringBuffer();
    output.writeln('{');
    output.writeln('id');
    output.writeln('title');
    if (coAuthor != null) {
      output.writeln('coAuthor ${coAuthor!}');
    }
    output.writeln('author $author');
    output.writeln('}');
    return output.toString();
  }
}
