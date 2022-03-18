part of couchify;

class Joins extends Query {
  final List<Join> _joins;

  Joins._(List serializedQuery, this._joins) : super(serializedQuery) {
    for (var join in _joins) {
      (serializedQuery[1]["FROM"] as List).add(join._serialize());
    }
  }

  Where where(Expression expression) {
    return Where._(_serializedQuery, expression);
  }
}
