enum QlObjectType {
  input,
  type,
  mutation,
  query,
  subscription;

  const QlObjectType();
  factory QlObjectType.from(String value) {
    switch (value) {
      case 'input':
        return QlObjectType.input;
      case 'type':
        return QlObjectType.type;
      case 'mutation':
        return QlObjectType.mutation;
      case 'query':
        return QlObjectType.query;
      case 'subscription':
        return QlObjectType.subscription;
      default:
        throw Exception('Invalid QlObjectType');
    }
  }

  /// Returns true if the object is a `query`, `mutation` or `subscription`.
  bool get isOperation =>
      this == QlObjectType.mutation ||
      this == QlObjectType.query ||
      this == QlObjectType.subscription;
}
