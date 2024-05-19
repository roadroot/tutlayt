<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->
# QlGen

**QlGen** is a library for generating dart code from GraphQL schema.

## Features

Given a GraphQL schema, QlGen generates dart code for the following:

- [x] Types
- [x] Queries
- [x] Mutations
- [-] Subscriptions (not yet tested)
- [ ] Fragments
- [ ] Enums
- [ ] Input Objects
- [ ] Unions
- [ ] Interfaces
- [ ] Scalars
- [ ] Custom scalars
- [ ] Custom directives
- [ ] Custom code generation
- [ ] Custom code generation for fragments
- [ ] Custom code generation for queries
- [ ] Custom code generation for mutations
- [ ] Custom code generation for subscriptions
- [ ] Custom code generation for enums
- [ ] Custom code generation for input objects
- [ ] Custom code generation for unions
- [ ] Custom code generation for interfaces
- [ ] Custom code generation for scalars
- [ ] Custom code generation for custom scalars
- [ ] Custom code generation for custom directives
- [ ] Custom code generation for custom types

## Getting started

To use this package, add `ql_gen` as a [dependency in your pubspec.yaml file](https://dart.dev/tools/pub/dependencies).

## Usage

<!-- command and result example -->

```bash
dart run .\bin\ql_gen.dart --help
```

```bash
-s, --source    The source file
                (defaults to "schema.gql")
-t, --target    The target file
                (defaults to "ql.dart")
-h, --help      Prints this help message
```

```bash
dart run .\bin\ql_gen.dart -s static/test/schema.gql -t ql.dart
```

```graphql
# schema.gql
type Author {
  id: ID!
  name: String!
  books: [Book]
}

type Book {
  id: ID!
  title: String!
  author: Author!
}
```

```dart
// ql.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

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
      books: data['books'],
    );
  }
  dynamic construct(dynamic data,
      {dynamic Function(Map<String, dynamic>)? fromMap}) {
    if (data is List) {
      return data.map((e) => construct(e, fromMap: fromMap));
    }
    if (fromMap != null) {
      return fromMap(data);
    }
    return data;
  }

  @override
  String toString() {
    StringBuffer output = StringBuffer();
    output.writeln('{');
    output.writeln('id: "$id"');
    output.writeln('name: "$name"');
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
  String select() {
    StringBuffer output = StringBuffer();
    output.writeln('{');
    output.writeln('id');
    output.writeln('name');
    if (books != null) {
      output.writeln('books ${books!.select()}');
    }
    output.writeln('}');
    return output.toString();
  }
}

class Book {
  final String id;
  final String title;
  final Author author;

  const Book({
    required this.id,
    required this.title,
    required this.author,
  });

  factory Book.fromMap(Map<String, dynamic> data) {
    return Book(
      id: data['id'],
      title: data['title'],
      author: data['author'],
    );
  }
  dynamic construct(dynamic data,
      {dynamic Function(Map<String, dynamic>)? fromMap}) {
    if (data is List) {
      return data.map((e) => construct(e, fromMap: fromMap));
    }
    if (fromMap != null) {
      return fromMap(data);
    }
    return data;
  }

  @override
  String toString() {
    StringBuffer output = StringBuffer();
    output.writeln('{');
    output.writeln('id: "$id"');
    output.writeln('title: "$title"');
    output.writeln('author: $author');

    output.writeln('}');
    return output.toString();
  }
}

class BookSelector {
  final AuthorSelector author;
  const BookSelector({
    this.author = const AuthorSelector(),
  });
  String select() {
    StringBuffer output = StringBuffer();
    output.writeln('{');
    output.writeln('id');
    output.writeln('title');
    output.writeln('author ${author.select()}');
    output.writeln('}');
    return output.toString();
  }
}
```
