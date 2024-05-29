import 'package:ql_gen/src/ql_gen/model/ql_field.dart';
import 'package:ql_gen/src/ql_gen/model/ql_method.dart';
import 'package:ql_gen/src/ql_gen/model/ql_object/ql_object.dart';
import 'package:ql_gen/src/ql_gen/model/ql_type.dart';
import 'package:ql_gen/src/ql_gen/utils/ql_object_handler.dart';
import 'package:ql_gen/src/ql_lang.dart';
import 'package:tokenizer/tokenizer.dart';

import 'model/native_type.dart';
import 'model/ql_object/ql_object_type.dart';

class QlParser {
  final List<QlObjectHandler> objects = [];
  QlParser();

  Set<NativeType> get nativeTypes =>
      objects.expand((e) => e.nativeTypes).toSet();

  visitTokens(List<Token> tokens) {
    for (Token token in tokens) {
      visitToken(token);
    }
  }

  visitToken(Token token) {
    if (token.model == QlLang.object) {
      objects.add(visitObject(token));
    }
  }

  QlObjectHandler visitObject(Token token) {
    assert(token.model == QlLang.object,
        'Invalid object token: $token, it should be an object token');
    assert(token.children.length == 5 || token.children.length == 4,
        'Invalid object token: $token, it should have 4 or 5 children, but it has ${token.children}');
    QlObjectType type = QlObjectType.from(token.children.first.value);
    if (type == QlObjectType.type) {
      if (token.children[1].value == 'Query') {
        type = QlObjectType.query;
      } else if (token.children[1].value == 'Mutation') {
        type = QlObjectType.mutation;
      } else if (token.children[1].value == 'Subscription') {
        type = QlObjectType.subscription;
      }
    }

    (List<QlField>, List<QlMethod>)? res;
    if (token.children[3].model == QlLang.fieldList) {
      res = visitFields(token.children[3], type);
    }
    return QlObjectHandler(QlObject(
      name: token.children[1].value,
      fields: res?.$1 ?? [],
      methods: res?.$2 ?? [],
      type: type,
    ));
  }

  (List<QlField>, List<QlMethod>) visitFields(
    Token token,
    QlObjectType objectType,
  ) {
    assert(token.model == QlLang.fieldList,
        'Invalid token: $token, it should be a field list token');
    if (token.children.isEmpty) return ([], []);
    var first = visitFieldOrMethod(token.children.first, objectType);
    if (token.children.length == 1) {
      return (
        first.$1 == null ? [] : [first.$1!],
        first.$2 == null ? [] : [first.$2!]
      );
    }
    var others = visitFields(token.children.sublist(1).first, objectType);
    return (
      first.$1 == null ? others.$1 : [first.$1!, ...others.$1],
      first.$2 == null ? others.$2 : [first.$2!, ...others.$2]
    );
  }

  (QlField?, QlMethod?) visitFieldOrMethod(
      Token token, QlObjectType objectType) {
    assert(token.model == QlLang.allField,
        'Invalid token: $token, it should be a field or method token');
    assert(token.children.length == 1,
        'Invalid token: $token, it should have a unique child, but it has ${token.children}');
    Token child = token.children.first;
    if (!objectType.isOperation && child.model == QlLang.simpleField) {
      return (visitField(child, QlFieldType.field), null);
    }
    return (null, visitMethod(child, objectType));
  }

  QlMethod visitMethod(Token token, QlObjectType objectType) {
    assert(
        token.model == QlLang.parameteredField ||
            token.model == QlLang.simpleField,
        'Invalid method token: $token, it should be a method token');
    assert(
      token.model != QlLang.parameteredField || token.children.length == 6,
      'Invalid method token, it should have 6 children: ${token.children}',
    );
    if (token.model == QlLang.simpleField) {
      return QlMethod(
        name: token.children.first.value,
        parameters: [],
        returnType: visitType(token.children.last),
        objectType: objectType,
      );
    }
    return QlMethod(
      name: token.children.first.value,
      parameters:
          token.children.length > 3 ? visitParameters(token.children[2]) : [],
      returnType: visitType(token.children.last),
      objectType: objectType,
    );
  }

  QlField visitField(Token token, QlFieldType fieldType) {
    assert(token.model == QlLang.simpleField,
        'Invalid field token: $token, it should be a simple field');
    assert(token.children.length == 3,
        'Invalid parameter token, it should have 3 children: ${token.children}');
    return QlField(
      name: token.children.first.value,
      type: visitType(token.children.last),
      fieldType: fieldType,
    );
  }

  List<QlField> visitParameters(Token token) {
    assert(token.model == QlLang.parameterList,
        'Invalid parameters token: $token, it should be a parameterList token');
    List<QlField> fields = [];
    if (token.children.isNotEmpty) {
      fields.add(visitField(token.children.first, QlFieldType.parameter));
      if (token.children.length > 1) {
        fields.addAll(visitParameters(token.children[2]));
      }
    }
    return fields;
  }

  QlType visitType(Token token) {
    if (token.children.isEmpty) {}
    bool isNullable = token.children.last.model != QlLang.exclamationToken;
    bool isList = token.children.first.model == QlLang.openBracket;
    if (isList) {
      assert(token.children.length >= 3,
          'Invalid type token: $token, lists should have at least 3 children');
      assert(token.children[1].model == QlLang.type,
          'Invalid type token: $token, lists should have a type as second child');
      return QlType(
        innerType: visitType(token.children[1]),
        isNullable: isNullable,
        isList: isList,
      );
    } else {
      return QlType(
        name: token.children.first.value,
        isNullable: isNullable,
        isList: isList,
      );
    }
  }
}
