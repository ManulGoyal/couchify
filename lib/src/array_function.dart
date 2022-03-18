part of couchify;

class ArrayFunction {
  static Expression contains(Expression expression, Expression value) {
    return Expression._operation("ARRAY_CONTAINS()", [expression, value]);
  }

  static Expression length(Expression expression) {
    return Expression._operation("ARRAY_LENGTH()", [expression]);
  }
}
