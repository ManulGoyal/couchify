part of couchify;

// import 'package:securevault/couchbase/expression.dart';

abstract class SelectResult {
  final Expression expr;

  SelectResult(this.expr);

  static SelectResultAs expression(Expression expression) {
    return SelectResultAs(expression);
  }

  static SelectResultFrom all() {
    return SelectResultFrom(Expression.all());
  }

  static SelectResultAs property(String property) {
    return SelectResultAs(Expression.property(property));
  }

  dynamic serialize();
}

class SelectResultAs extends SelectResult {
  String? alias;

  SelectResultAs(Expression expression) : super(expression);

  SelectResult as(String alias) {
    this.alias = alias;
    return this;
  }

  @override
  dynamic serialize() {
    if (alias == null)
      return expr.serialize();
    else
      return ["AS", expr.serialize(), alias];
  }
}

class SelectResultFrom extends SelectResult {
  String? alias;

  SelectResultFrom(Expression expression) : super(expression);

  SelectResult from(String alias) {
    this.alias = alias;
    return this;
  }

  @override
  dynamic serialize() {
    if (alias == null)
      return expr.serialize();
    else
      return (expr as PropertyExpression).from(alias!).serialize();
  }
}
