part of couchify;

// import 'package:securevault/couchbase/data_source.dart';
// import 'package:securevault/couchbase/expression.dart';

class Join {
  final DataSource dataSource;
  final String joinType;

  Join(this.dataSource, this.joinType);

  static Join crossJoin(DataSource dataSource) {
    return Join(dataSource, "CROSS");
  }

  static JoinOn innerJoin(DataSource dataSource) {
    return JoinOn(dataSource, "INNER");
  }

  static JoinOn join(DataSource dataSource) {
    return innerJoin(dataSource);
  }

  static JoinOn leftOuterJoin(DataSource dataSource) {
    return JoinOn(dataSource, "LEFT OUTER");
  }

  static JoinOn leftJoin(DataSource dataSource) {
    return leftOuterJoin(dataSource);
  }

  Map<String, dynamic> serialize() {
    var value = dataSource.serialize();
    value["JOIN"] = joinType;
    return value;
  }
}

class JoinOn extends Join {
  Expression expression = Expression.booleanValue(true);

  JoinOn(DataSource dataSource, String joinType) : super(dataSource, joinType);

  Join on(Expression expression) {
    this.expression = expression;
    return this;
  }

  @override
  Map<String, dynamic> serialize() {
    var value = super.serialize();
    value["ON"] = expression.serialize();
    return value;
  }
}
