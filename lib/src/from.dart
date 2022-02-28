part of couchify;

// import 'package:securevault/couchbase/query.dart';
// import 'package:securevault/couchbase/where.dart';
// import 'package:securevault/couchbase/join.dart';
// import 'package:securevault/couchbase/joins.dart';
// import 'package:securevault/couchbase/data_source.dart';
// import 'package:securevault/couchbase/expression.dart';

class From extends Query {
  final DataSource dataSrc;

  From(List serializedQuery, this.dataSrc) : super(serializedQuery) {
    serializedQuery[1]["FROM"] = <dynamic>[dataSrc.serialize()];
  }

  Where where(Expression expression) {
    return Where(serializedQuery, expression);
  }

  Joins join(List<Join> joins) {
    return Joins(serializedQuery, joins);
  }
}
