part of couchify;

// import 'package:securevault/couchbase.dart';

class Expression {
  String? operator;
  List<Expression>? operands;
  dynamic literalValue;

  Expression();

  Expression.operation(this.operator, this.operands);

  Expression.literal(this.literalValue);

  dynamic serialize() {
    if (operator == null) {
      // if (literalValue is List)
      //   return <dynamic>["[]", ...literalValue];
      // else
      if (literalValue is Map<String, Expression>)
        return (literalValue as Map<String, Expression>)
            .map((key, value) => MapEntry(key, value.serialize()));
      return literalValue;
    } else {
      if (operands == null)
        return <dynamic>[operator];
      else
        return <dynamic>[
          operator,
          ...(operands!.map((operand) => operand.serialize()).toList())
        ];
    }
  }

  // Expression add(Expression expression);
  static PropertyExpression all() {
    return PropertyExpression(".");
  }

  static PropertyExpression property(String property) {
    return PropertyExpression("." + property);
  }

  static Expression intValue(int value) {
    return Expression.literal(value);
  }

  static Expression string(String value) {
    return Expression.literal(value);
  }

  static Expression booleanValue(bool value) {
    return Expression.literal(value);
  }

  static Expression date(DateTime value) {
    return Expression.literal(value.toIso8601String());
  }

  static Expression value(dynamic value) {
    if (value is Expression) return value;
    if (value is List) return list(value);
    if (value is Map<String, dynamic>) return map(value);
    if (value is DateTime) return date(value);
    return Expression.literal(value);
  }

  static Expression list(List value) {
    return Expression.operation(
        "[]", value.map((item) => Expression.value(item)).toList());
  }

  // returns an Expression object with value of runtime type Map<String, Expression>
  static Expression map(Map<String, dynamic> value) {
    return Expression.literal(
        value.map((key, value) => MapEntry(key, Expression.value(value))));
  }

  Expression equalTo(Expression expression) {
    return Expression.operation("=", [this, expression]);
  }

  Expression lessThan(Expression expression) {
    return Expression.operation("<", [this, expression]);
  }

  Expression greaterThan(Expression expression) {
    return Expression.operation(">", [this, expression]);
  }

  Expression lessThanOrEqualTo(Expression expression) {
    return Expression.operation("<=", [this, expression]);
  }

  Expression greaterThanOrEqualTo(Expression expression) {
    return Expression.operation(">=", [this, expression]);
  }

  static Expression not(Expression expression) {
    return Expression.operation("NOT", [expression]);
  }

  static Expression negated(Expression expression) {
    return not(expression);
  }

  Expression and(Expression expression) {
    return Expression.operation("AND", [this, expression]);
  }

  Expression or(Expression expression) {
    return Expression.operation("OR", [this, expression]);
  }

  Expression add(Expression expression) {
    return Expression.operation("+", [this, expression]);
  }

  Expression subtract(Expression expression) {
    return Expression.operation("-", [this, expression]);
  }

  Expression multiply(Expression expression) {
    return Expression.operation("*", [this, expression]);
  }

  Expression notEqualTo(Expression expression) {
    return Expression.operation("!=", [this, expression]);
  }
}

class MetaExpression extends Expression {
  final String property;
  String? alias;

  MetaExpression(this.property);

  Expression from(String alias) {
    this.alias = alias;
    return this;
  }

  @override
  dynamic serialize() {
    if (alias == null)
      return [property];
    else
      return [".$alias$property"];
  }
}

class PropertyExpression extends Expression {
  final String property;
  String? alias;

  PropertyExpression(this.property);

  Expression from(String alias) {
    this.alias = alias;
    return this;
  }

  @override
  dynamic serialize() {
    if (alias == null)
      return [property];
    else if (property == ".")
      return [".$alias"];
    else
      return [".$alias$property"];
  }
}

class VariableExpression extends Expression {
  final String variable;

  VariableExpression(this.variable);

  @override
  dynamic serialize() {
    return ["?$variable"];
  }
}
