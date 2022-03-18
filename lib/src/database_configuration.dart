part of couchify;

// import 'package:flutter/cupertino.dart';
// import 'package:path_provider/path_provider.dart';

class DatabaseConfiguration {
  String _directory = CouchbaseLite._applicationFilesDir;

  /// set absolute path of directory to create/open the database in
  DatabaseConfiguration setDirectory(String directory) {
    _directory = directory;
    return this;
  }
}
