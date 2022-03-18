part of couchify;

class Where extends Query {
  final Expression _expression;

  Where._(List serializedQuery, this._expression) : super(serializedQuery) {
    serializedQuery[1]["WHERE"] = _expression._serialize();
  }
}
