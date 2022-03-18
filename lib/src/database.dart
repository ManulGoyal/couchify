part of couchify;

class Database {
  final String _name;
  final DatabaseConfiguration _configuration;
  late final String _id;

  Database._(this._name, this._configuration) {
    if (_configuration._directory.endsWith("/") ||
        _configuration._directory.endsWith("\\")) {
      _id = "${_configuration._directory}$_name";
    } else {
      _id = "${_configuration._directory}/$_name";
    }
  }

  static Future<Database> open(
      String name, DatabaseConfiguration configuration) async {
    var database = Database._(name, configuration);
    await CouchbaseLiteWrapper().openDatabase(database._id);
    return database;
  }

  DatabaseConfiguration getConfig() {
    return _configuration;
  }

  Future<String> getPath() async {
    return await CouchbaseLiteWrapper().getDatabasePath(_id);
  }

  Future save(MutableDocument document) async {
    await CouchbaseLiteWrapper()
        .saveDocument(_id, document.getId(), document.toMap());
  }

  Future close() async {
    await CouchbaseLiteWrapper().closeDatabase(_id);
  }

  Future delete() async {
    await CouchbaseLiteWrapper().deleteDatabase(_id);
  }

  Future deleteDocument(Document document) async {
    await CouchbaseLiteWrapper().deleteDocument(_id, document.getId());
  }

  Future<int> getCount() async {
    return await CouchbaseLiteWrapper().getCount(_id);
  }

  Future<Document?> getDocument(String id) async {
    var documentMap = Map<String, dynamic>.from(
        await CouchbaseLiteWrapper().getDocument(_id, id));
    if (!documentMap.containsKey("id") || !documentMap.containsKey("data")) {
      return null;
    }
    var documentId = documentMap["id"] as String;
    var documentData = Map<String, dynamic>.from(documentMap["data"]);
    return Document._data(documentId, documentData);
  }
}
