part of couchify;

// import 'package:securevault/couchbase.dart';

class ArrayFunction {
  static Expression contains(Expression expression, Expression value) {
    return Expression.operation("ARRAY_CONTAINS()", [expression, value]);
  }

  static Expression length(Expression expression) {
    return Expression.operation("ARRAY_LENGTH()", [expression]);
  }
}
