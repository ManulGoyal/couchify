part of couchify;

class Join {
  final DataSource _dataSource;
  final String _joinType;

  Join(this._dataSource, this._joinType);

  static Join crossJoin(DataSource dataSource) {
    return Join(dataSource, "CROSS");
  }

  static JoinOn innerJoin(DataSource dataSource) {
    return JoinOn._(dataSource, "INNER");
  }

  static JoinOn join(DataSource dataSource) {
    return innerJoin(dataSource);
  }

  static JoinOn leftOuterJoin(DataSource dataSource) {
    return JoinOn._(dataSource, "LEFT OUTER");
  }

  static JoinOn leftJoin(DataSource dataSource) {
    return leftOuterJoin(dataSource);
  }

  Map<String, dynamic> _serialize() {
    var value = _dataSource._serialize();
    value["JOIN"] = _joinType;
    return value;
  }
}

class JoinOn extends Join {
  Expression _expression = Expression.booleanValue(true);

  JoinOn._(DataSource dataSource, String joinType)
      : super(dataSource, joinType);

  Join on(Expression expression) {
    _expression = expression;
    return this;
  }

  @override
  Map<String, dynamic> _serialize() {
    var value = super._serialize();
    value["ON"] = _expression._serialize();
    return value;
  }
}
