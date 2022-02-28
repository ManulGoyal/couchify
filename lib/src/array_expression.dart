part of couchify;

// import 'expression.dart';

class ArrayExpression {
  static ArrayExpressionIn any(VariableExpression variable) {
    return ArrayExpressionIn("ANY", variable);
  }

  static ArrayExpressionIn anyAndEvery(VariableExpression variable) {
    return ArrayExpressionIn("ANY AND EVERY", variable);
  }

  static ArrayExpressionIn every(VariableExpression variable) {
    return ArrayExpressionIn("EVERY", variable);
  }

  static VariableExpression variable(String name) {
    return VariableExpression(name);
  }
}

class ArrayExpressionIn {
  final String operator;
  final VariableExpression variable;

  ArrayExpressionIn(this.operator, this.variable);

  ArrayExpressionSatisfies inside(Expression expression) {
    return ArrayExpressionSatisfies(operator, variable, expression);
  }
}

class ArrayExpressionSatisfies {
  final String operator;
  final VariableExpression variable;
  final Expression arrayExpression;

  ArrayExpressionSatisfies(this.operator, this.variable, this.arrayExpression);

  Expression satisfies(Expression expression) {
    return Expression.operation(operator,
        [Expression.string(variable.variable), arrayExpression, expression]);
  }
}
