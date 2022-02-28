part of couchify;

// import 'package:securevault/couchbase/database.dart';

abstract class DataSource {
  final Database db;

  DataSource(this.db);

  static DataSourceAs database(Database database) {
    return DataSourceAs(database);
  }

  Map<String, dynamic> serialize();
}

class DataSourceAs extends DataSource {
  String? alias;

  DataSourceAs(Database database) : super(database);

  DataSource as(String alias) {
    this.alias = alias;
    return this;
  }

  @override
  Map<String, dynamic> serialize() {
    var value = <String, dynamic>{"COLLECTION": db._id};
    if (alias != null) value["AS"] = alias;
    return value;
  }
}
