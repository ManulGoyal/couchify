part of couchify;

class ResultsIterator {
  final String _resultSetId;
  Result? _current;

  ResultsIterator(this._resultSetId);

  Result? get current => _current;

  Future<bool> moveNext() async {
    var resultMap = Map<String, dynamic>.from(
        await CouchbaseLiteWrapper().resultSetNext(_resultSetId));
    if (resultMap.isEmpty) {
      _current = null;
      return false;
    } else {
      _current = Result._(resultMap);
      return true;
    }
  }
}
