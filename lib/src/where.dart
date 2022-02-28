part of couchify;

// import 'package:securevault/couchbase/query.dart';
// import 'package:securevault/couchbase/expression.dart';

class Where extends Query {
  final Expression expression;

  Where(List serializedQuery, this.expression) : super(serializedQuery) {
    serializedQuery[1]["WHERE"] = expression.serialize();
  }
}
