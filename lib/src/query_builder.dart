part of couchify;

// import 'package:securevault/couchbase/select.dart';
// import 'package:securevault/couchbase/select_result.dart';

class QueryBuilder {
  // static Map<String, dynamic> query;

  static Select select([List<SelectResult> results = const []]) {
    return Select(<dynamic>[], results);
  }
}
