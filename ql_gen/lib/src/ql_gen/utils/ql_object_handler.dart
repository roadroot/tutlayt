import 'package:ql_gen/src/ql_gen/model/ql_object/ql_object.dart';

import '../model/native_type.dart';

class QlObjectHandler {
  final QlObject object;

  const QlObjectHandler(this.object);

  /// Returns a set of native types used in the fields.
  ///
  /// calling from an object having as fields :
  /// - names: `List<List<String>>`
  /// - age: `List<int>`
  /// - registredAt: `DateTime`
  ///
  /// will return: `{NativeType.string, NativeType.int, NativeType.dateTime}`
  Set<NativeType> get nativeTypes => object.fields
      .map((e) => e.type.coreType.nativeType)
      .followedBy(object.methods
          .expand((e) => e.parameters.map((e) => e.type.coreType.nativeType)))
      .whereType<NativeType>()
      .toSet();

  @override
  String toString() {
    return object.toString();
  }
}
