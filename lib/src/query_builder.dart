part of couchify;

class QueryBuilder {
  static Select select([List<SelectResult> results = const []]) {
    return Select._(<dynamic>[], results);
  }
}
