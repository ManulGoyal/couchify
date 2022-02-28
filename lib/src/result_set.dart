part of couchify;

class ResultSet {
  final String _id;

  ResultSet._(this._id);

  Stream<Result> getStream() async* {
    while (true) {
      var result = await next();
      if (result == null) break;
      yield result;
    }
  }

  Future<List<Result>> allResults() async {
    var results = await CouchbaseLiteWrapper().resultSetAllResults(_id);

    return results.map((result) {
      var resultData =
          Map<String, dynamic>.from(result as Map<dynamic, dynamic>);
      return Result._(resultData);
    }).toList();
  }

  Future<Result?> next() async {
    var result = await CouchbaseLiteWrapper().resultSetNext(_id);
    var resultMap = Map<String, dynamic>.from(result);

    if (resultMap.isEmpty) return null;
    return Result._(resultMap);
  }
}
