part of couchify;

class CouchbaseLite {
  static String? __applicationFilesDir;

  static String get _applicationFilesDir {
    if (__applicationFilesDir == null) {
      throw Exception(
          "CouchbaseLite.init() must be called before using any other Couchbase Lite API");
    }
    return __applicationFilesDir!;
  }

  static Future init() async {
    __applicationFilesDir = await CouchbaseLiteWrapper().couchbaseLiteInit();
  }
}
