import 'package:graphql_decorator/annotations.dart';

part 'graphql.g.dart';

@QlEntity(name: 'article')
abstract class Article {
  @QlField(name: 'titre')
  String title = '';

  @QlField()
  int price = 0;

  @QlQuery()
  getArticle();
}

@QlEntity(name: 'cart')
abstract class Cart {
  @QlField()
  List<Article> articles = [];

  @QlField()
  List<String> tags = [];

  @QlField()
  Article? promotion;

  @QlQuery(name: 'cart')
  String getCart(String id, String? name, int? age, List<Article>? article);

  @QlMutation(name: 'cart')
  Cart createCart(String id, String? name, int? age, Article? article);
}
