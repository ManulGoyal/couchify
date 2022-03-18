part of couchify;

class From extends Query {
  final DataSource _dataSrc;

  From._(List serializedQuery, this._dataSrc) : super(serializedQuery) {
    serializedQuery[1]["FROM"] = <dynamic>[_dataSrc._serialize()];
  }

  Where where(Expression expression) {
    return Where._(_serializedQuery, expression);
  }

  Joins join(List<Join> joins) {
    return Joins._(_serializedQuery, joins);
  }
}
