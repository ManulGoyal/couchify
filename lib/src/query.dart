part of couchify;

// import 'package:securevault/couchbase/result_set.dart';
// import 'package:securevault/pigeon.dart';

abstract class Query {
  final List serializedQuery;

  Query(this.serializedQuery);

  Future<ResultSet> execute() async {
    String resultSetId =
        await CouchbaseLiteWrapper().executeQuery(serializedQuery);

    return ResultSet._(resultSetId);

    // result.map((e) => Map<String?, Object?>.from(e as Map<Object?, Object?>));

    // return result
    //     .map((e) => Map<String, dynamic>.from(e as Map<dynamic, dynamic>))
    //     .toList();
    // print(serializedQuery);
    //
    // var encoder = new JsonEncoder.withIndent("     ");
    // print(encoder.convert(serializedQuery));
    //
    // return ResultSet();
  }

  // static Future<int> getValue() async {
  //   return await CouchbaseLiteWrapper().getValue();
  // }
}
