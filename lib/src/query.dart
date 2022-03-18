part of couchify;

abstract class Query {
  final List _serializedQuery;

  Query(this._serializedQuery);

  Future<ResultSet> execute() async {
    String resultSetId =
        await CouchbaseLiteWrapper().executeQuery(_serializedQuery);

    return ResultSet._(resultSetId);
  }
}
