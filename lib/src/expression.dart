part of couchify;

class Expression {
  String? _operator;
  List<Expression>? _operands;
  dynamic _literalValue;

  Expression._();

  Expression._operation(this._operator, this._operands);

  Expression._literal(this._literalValue);

  dynamic _serialize() {
    if (_operator == null) {
      if (_literalValue is Map<String, Expression>) {
        return (_literalValue as Map<String, Expression>)
            .map((key, value) => MapEntry(key, value._serialize()));
      }
      return _literalValue;
    }
    if (_operands == null) {
      return <dynamic>[_operator];
    }
    return <dynamic>[
      _operator,
      ...(_operands!.map((operand) => operand._serialize()).toList())
    ];
  }

  static PropertyExpression all() {
    return PropertyExpression._(".");
  }

  static PropertyExpression property(String property) {
    return PropertyExpression._("." + property);
  }

  static Expression intValue(int value) {
    return Expression._literal(value);
  }

  static Expression string(String value) {
    return Expression._literal(value);
  }

  static Expression booleanValue(bool value) {
    return Expression._literal(value);
  }

  static Expression date(DateTime value) {
    return Expression._literal(value.toUtc().toIso8601String());
  }

  static Expression value(dynamic value) {
    if (value is Expression) return value;
    if (value is List) return list(value);
    if (value is Map<String, dynamic>) return map(value);
    if (value is DateTime) return date(value);
    return Expression._literal(value);
  }

  static Expression list(List value) {
    return Expression._operation(
        "[]", value.map((item) => Expression.value(item)).toList());
  }

  // returns an Expression object with value of runtime type Map<String, Expression>
  static Expression map(Map<String, dynamic> value) {
    return Expression._literal(
        value.map((key, value) => MapEntry(key, Expression.value(value))));
  }

  Expression equalTo(Expression expression) {
    return Expression._operation("=", [this, expression]);
  }

  Expression lessThan(Expression expression) {
    return Expression._operation("<", [this, expression]);
  }

  Expression greaterThan(Expression expression) {
    return Expression._operation(">", [this, expression]);
  }

  Expression lessThanOrEqualTo(Expression expression) {
    return Expression._operation("<=", [this, expression]);
  }

  Expression greaterThanOrEqualTo(Expression expression) {
    return Expression._operation(">=", [this, expression]);
  }

  static Expression not(Expression expression) {
    return Expression._operation("NOT", [expression]);
  }

  static Expression negated(Expression expression) {
    return not(expression);
  }

  Expression and(Expression expression) {
    return Expression._operation("AND", [this, expression]);
  }

  Expression or(Expression expression) {
    return Expression._operation("OR", [this, expression]);
  }

  Expression add(Expression expression) {
    return Expression._operation("+", [this, expression]);
  }

  Expression subtract(Expression expression) {
    return Expression._operation("-", [this, expression]);
  }

  Expression multiply(Expression expression) {
    return Expression._operation("*", [this, expression]);
  }

  Expression notEqualTo(Expression expression) {
    return Expression._operation("!=", [this, expression]);
  }

  Expression like(Expression expression) {
    return Expression._operation("LIKE", [this, expression]);
  }

  Expression regex(Expression expression) {
    return Expression._operation("REGEXP_LIKE()", [this, expression]);
  }
}

class MetaExpression extends Expression {
  final String _property;
  String? _alias;

  MetaExpression._(this._property) : super._();

  Expression from(String alias) {
    _alias = alias;
    return this;
  }

  @override
  dynamic _serialize() {
    if (_alias == null) {
      return [_property];
    } else {
      return [".$_alias$_property"];
    }
  }
}

class PropertyExpression extends Expression {
  final String _property;
  String? _alias;

  PropertyExpression._(this._property) : super._();

  Expression from(String alias) {
    _alias = alias;
    return this;
  }

  @override
  dynamic _serialize() {
    if (_alias == null) {
      return [_property];
    } else if (_property == ".") {
      return [".$_alias"];
    } else {
      return [".$_alias$_property"];
    }
  }
}

class VariableExpression extends Expression {
  final String _variable;

  VariableExpression._(this._variable) : super._();

  @override
  dynamic _serialize() {
    return ["?$_variable"];
  }
}
