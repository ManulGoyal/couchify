part of couchify;

class Select extends Query {
  final List<SelectResult> _results;

  Select._(List serializedQuery, this._results) : super(serializedQuery) {
    serializedQuery.add("SELECT");
    var operand = <String, dynamic>{};
    operand["WHAT"] =
        _results.map<dynamic>((result) => result._serialize()).toList();

    serializedQuery.add(operand);
  }

  From from(DataSource dataSource) {
    return From._(_serializedQuery, dataSource);
  }
}
