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
  final List<Book?>? books;

  const Author({
    required this.id,
    required this.name,
    this.books,
  });

  factory Author.fromMap(Map<String, dynamic> data) {
    return Author(
      id: data['id'],
      name: data['name'],
      books: construct(data['books'], fromMap: Book.fromMap)?.cast<Book>(),
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

    output.writeln('}');
    return output.toString();
  }
}

class AuthorSelector {
  final BookSelector? books;
  const AuthorSelector({
    this.books,
  });
  @override
  String toString() {
    StringBuffer output = StringBuffer();
    output.writeln('{');
    output.writeln('id');
    output.writeln('name');
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
  final Author? author;

  const Book({
    required this.id,
    required this.title,
    this.author,
  });

  factory Book.fromMap(Map<String, dynamic> data) {
    return Book(
      id: data['id'],
      title: data['title'],
      author: data['author'] == null ? null : Author.fromMap(data['author']),
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
    if (author != null) {
      output.writeln('author: $author');
    }

    output.writeln('}');
    return output.toString();
  }
}

class BookSelector {
  final AuthorSelector? author;
  const BookSelector({
    this.author,
  });
  @override
  String toString() {
    StringBuffer output = StringBuffer();
    output.writeln('{');
    output.writeln('id');
    output.writeln('title');
    if (author != null) {
      output.writeln('author ${author!}');
    }
    output.writeln('}');
    return output.toString();
  }
}

class Mutation {
  final Future<Map<String, dynamic>?> Function(String query) _executor;

  const Mutation(this._executor);

  Future<Author?> createAuthor(
    AuthorSelector $selector,
    String name,
  ) async {
    return construct(
      (await _executor(createAuthorQl(
        $selector,
        name,
      )))?['createAuthor'],
      fromMap: Author.fromMap,
    );
  }

  String createAuthorQl(
    AuthorSelector $selector,
    String name,
  ) {
    StringBuffer output = StringBuffer();
    output.writeln('mutation {');
    output.writeln('createAuthor(');
    output.writeln(
        'name: "${name.replaceAll('\\', r'\\\\').replaceAll('\n', r'\\n').replaceAll('\r', r'\\r').replaceAll('\t', r'\\t').replaceAll('"', r'\\\"')}"');
    output.writeln(')');
    output.writeln($selector);
    output.writeln('}');
    return output.toString();
  }

  Future<Book?> createBook(
    BookSelector $selector,
    String title,
    String authorId,
  ) async {
    return construct(
      (await _executor(createBookQl(
        $selector,
        title,
        authorId,
      )))?['createBook'],
      fromMap: Book.fromMap,
    );
  }

  String createBookQl(
    BookSelector $selector,
    String title,
    String authorId,
  ) {
    StringBuffer output = StringBuffer();
    output.writeln('mutation {');
    output.writeln('createBook(');
    output.writeln(
        'title: "${title.replaceAll('\\', r'\\\\').replaceAll('\n', r'\\n').replaceAll('\r', r'\\r').replaceAll('\t', r'\\t').replaceAll('"', r'\\\"')}"');
    output.writeln(
        'authorId: "${authorId.replaceAll('\\', r'\\\\').replaceAll('\n', r'\\n').replaceAll('\r', r'\\r').replaceAll('\t', r'\\t').replaceAll('"', r'\\\"')}"');
    output.writeln(')');
    output.writeln($selector);
    output.writeln('}');
    return output.toString();
  }

  Future<bool?> refresh() async {
    return construct(
      (await _executor(refreshQl()))?['refresh'],
    );
  }

  String refreshQl() {
    StringBuffer output = StringBuffer();
    output.writeln('mutation {');
    output.writeln('refresh');
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

class Query {
  final Future<Map<String, dynamic>?> Function(String query) _executor;

  const Query(this._executor);

  Future<List<Author?>?> authors(
    AuthorSelector $selector,
  ) async {
    return construct(
      (await _executor(authorsQl(
        $selector,
      )))?['authors'],
      fromMap: Author.fromMap,
    );
  }

  String authorsQl(
    AuthorSelector $selector,
  ) {
    StringBuffer output = StringBuffer();
    output.writeln('query {');
    output.writeln('authors');
    output.writeln($selector);
    output.writeln('}');
    return output.toString();
  }

  Future<List<Book?>?> books(
    BookSelector $selector,
  ) async {
    return construct(
      (await _executor(booksQl(
        $selector,
      )))?['books'],
      fromMap: Book.fromMap,
    );
  }

  String booksQl(
    BookSelector $selector,
  ) {
    StringBuffer output = StringBuffer();
    output.writeln('query {');
    output.writeln('books');
    output.writeln($selector);
    output.writeln('}');
    return output.toString();
  }

  Future<Author?> author(
    AuthorSelector $selector,
    String id,
  ) async {
    return construct(
      (await _executor(authorQl(
        $selector,
        id,
      )))?['author'],
      fromMap: Author.fromMap,
    );
  }

  String authorQl(
    AuthorSelector $selector,
    String id,
  ) {
    StringBuffer output = StringBuffer();
    output.writeln('query {');
    output.writeln('author(');
    output.writeln(
        'id: "${id.replaceAll('\\', r'\\\\').replaceAll('\n', r'\\n').replaceAll('\r', r'\\r').replaceAll('\t', r'\\t').replaceAll('"', r'\\\"')}"');
    output.writeln(')');
    output.writeln($selector);
    output.writeln('}');
    return output.toString();
  }

  Future<Book?> book(
    BookSelector $selector,
    String id,
  ) async {
    return construct(
      (await _executor(bookQl(
        $selector,
        id,
      )))?['book'],
      fromMap: Book.fromMap,
    );
  }

  String bookQl(
    BookSelector $selector,
    String id,
  ) {
    StringBuffer output = StringBuffer();
    output.writeln('query {');
    output.writeln('book(');
    output.writeln(
        'id: "${id.replaceAll('\\', r'\\\\').replaceAll('\n', r'\\n').replaceAll('\r', r'\\r').replaceAll('\t', r'\\t').replaceAll('"', r'\\\"')}"');
    output.writeln(')');
    output.writeln($selector);
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
