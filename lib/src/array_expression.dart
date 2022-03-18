part of couchify;

class ArrayExpression {
  static ArrayExpressionIn any(VariableExpression variable) {
    return ArrayExpressionIn._("ANY", variable);
  }

  static ArrayExpressionIn anyAndEvery(VariableExpression variable) {
    return ArrayExpressionIn._("ANY AND EVERY", variable);
  }

  static ArrayExpressionIn every(VariableExpression variable) {
    return ArrayExpressionIn._("EVERY", variable);
  }

  static VariableExpression variable(String name) {
    return VariableExpression._(name);
  }
}

class ArrayExpressionIn {
  final String _operator;
  final VariableExpression _variable;

  ArrayExpressionIn._(this._operator, this._variable);

  ArrayExpressionSatisfies inside(Expression expression) {
    return ArrayExpressionSatisfies._(_operator, _variable, expression);
  }
}

class ArrayExpressionSatisfies {
  final String _operator;
  final VariableExpression _variable;
  final Expression _arrayExpression;

  ArrayExpressionSatisfies._(
      this._operator, this._variable, this._arrayExpression);

  Expression satisfies(Expression expression) {
    return Expression._operation(_operator,
        [Expression.string(_variable._variable), _arrayExpression, expression]);
  }
}
