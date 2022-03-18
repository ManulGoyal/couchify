part of couchify;

abstract class SelectResult {
  final Expression _expr;

  SelectResult._(this._expr);

  static SelectResultAs expression(Expression expression) {
    return SelectResultAs._(expression);
  }

  static SelectResultFrom all() {
    return SelectResultFrom._(Expression.all());
  }

  static SelectResultAs property(String property) {
    return SelectResultAs._(Expression.property(property));
  }

  dynamic _serialize();
}

class SelectResultAs extends SelectResult {
  String? _alias;

  SelectResultAs._(Expression expression) : super._(expression);

  SelectResult as(String alias) {
    _alias = alias;
    return this;
  }

  @override
  dynamic _serialize() {
    if (_alias == null) {
      return _expr._serialize();
    } else {
      return ["AS", _expr._serialize(), _alias];
    }
  }
}

class SelectResultFrom extends SelectResult {
  String? _alias;

  SelectResultFrom._(Expression expression) : super._(expression);

  SelectResult from(String alias) {
    _alias = alias;
    return this;
  }

  @override
  dynamic _serialize() {
    if (_alias == null) {
      return _expr._serialize();
    } else {
      return (_expr as PropertyExpression).from(_alias!)._serialize();
    }
  }
}
