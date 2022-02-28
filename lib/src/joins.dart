part of couchify;

// import 'package:securevault/couchbase/query.dart';
// import 'package:securevault/couchbase/join.dart';
// import 'package:securevault/couchbase/where.dart';
// import 'package:securevault/couchbase/expression.dart';

class Joins extends Query {
  final List<Join> joins;

  Joins(List serializedQuery, this.joins) : super(serializedQuery) {
    joins.forEach((join) {
      (serializedQuery[1]["FROM"] as List).add(join.serialize());
    });
  }

  Where where(Expression expression) {
    return Where(serializedQuery, expression);
  }
}
