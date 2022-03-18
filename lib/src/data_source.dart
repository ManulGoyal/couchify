part of couchify;

// import 'package:securevault/couchbase/database.dart';

abstract class DataSource {
  final Database _db;

  DataSource(this._db);

  static DataSourceAs database(Database database) {
    return DataSourceAs._(database);
  }

  Map<String, dynamic> _serialize();
}

class DataSourceAs extends DataSource {
  String? _alias;

  DataSourceAs._(Database database) : super(database);

  DataSource as(String alias) {
    _alias = alias;
    return this;
  }

  @override
  Map<String, dynamic> _serialize() {
    var value = <String, dynamic>{"COLLECTION": _db._id};
    if (_alias != null) value["AS"] = _alias;
    return value;
  }
}
