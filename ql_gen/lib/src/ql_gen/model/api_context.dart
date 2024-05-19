import 'package:ql_gen/src/ql_gen/utils/ql_object_handler.dart';

import 'native_type.dart';

class ApiContext {
  final List<QlObjectHandler> _objects = [];
  List<QlObjectHandler> get objects => _objects;

  Set<NativeType> get nativeTypes => objects.map((e) => e.nativeTypes).fold(
        {},
        (previousValue, element) => previousValue.union(element),
      );
}
