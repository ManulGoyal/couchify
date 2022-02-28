part of couchify;

// import 'package:securevault/couchbase/database_configuration.dart';
// import 'document.dart';
// import 'package:securevault/pigeon.dart';

class Database {
  final String _name;
  final DatabaseConfiguration _configuration;
  late final String _id;
  bool _opened = false;

  Database(this._name, this._configuration) {
    if (_configuration.directory.endsWith("/") ||
        _configuration.directory.endsWith("\\")) {
      _id = "${_configuration.directory}$_name";
    } else {
      _id = "${_configuration.directory}/$_name";
    }
  }

  Future _open() async {
    if (_opened) return;
    await CouchbaseLiteWrapper().openDatabase(_id);
    _opened = true;
  }

  DatabaseConfiguration getConfig() {
    return _configuration;
  }

  Future<String> getPath() async {
    await _open();
    return await CouchbaseLiteWrapper().getDatabasePath(_id);
  }

  Future save(MutableDocument document) async {
    await _open();
    await CouchbaseLiteWrapper()
        .saveDocument(_id, document.getId(), document.toMap());
    // return Document._data(response.map((key, value) => MapEntry(key!, value)));
  }

  Future close() async {
    _opened = false;
    await CouchbaseLiteWrapper().closeDatabase(_id);
  }

  Future<Document> get(String id) async {
    await _open();
    var documentMap = Map<String, dynamic>.from(
        await CouchbaseLiteWrapper().getDocument(_id, id));
    if (!documentMap.containsKey("id") || !documentMap.containsKey("data")) {
      throw Exception(
          "Invalid document map format received from platform channel");
    }
    var documentId = documentMap["id"] as String;
    var documentData = Map<String, dynamic>.from(documentMap["data"]);
    return Document._data(documentId, documentData);
  }
}
