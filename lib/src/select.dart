part of couchify;

// import 'package:securevault/couchbase/query.dart';
// import 'package:securevault/couchbase/select_result.dart';
// import 'package:securevault/couchbase/data_source.dart';
// import 'package:securevault/couchbase/from.dart';

class Select extends Query {
  final List<SelectResult> results;

  Select(List serializedQuery, this.results) : super(serializedQuery) {
    serializedQuery.add("SELECT");
    var operand = Map<String, dynamic>();
    operand["WHAT"] =
        results.map<dynamic>((result) => result.serialize()).toList();

    serializedQuery.add(operand);
  }

  From from(DataSource dataSource) {
    return From(serializedQuery, dataSource);
  }
}
