part of couchify;

// import 'package:securevault/couchbase/array.dart';
// import 'package:securevault/couchbase/dictionary.dart';
// import 'package:uuid/uuid.dart';

class Document {
  late final Map<String, dynamic> _data;
  late final String _id;

  Document._();
  Document._data(this._id, this._data);

  bool contains(String key) {
    return _data.containsKey(key);
  }

  int count() {
    return _data.length;
  }

  List<String> getKeys() {
    return _data.keys.toList();
  }

  String getId() {
    return _id;
  }

  bool isDeleted() {
    return _data["_deleted"] as bool;
  }

  int getSequence() {
    return _data["_sequence"] as int;
  }

  bool getBoolean(String key) {
    return _data[key] as bool;
  }

  num getNumber(String key) {
    return _data[key] as num;
  }

  int getInt(String key) {
    return _data[key] as int;
  }

  int getLong(String key) {
    return getInt(key);
  }

  double getDouble(String key) {
    return _data[key] as double;
  }

  double getFloat(String key) {
    return getDouble(key);
  }

  DateTime getDate(String key) {
    return DateTime.parse(_data[key] as String);
  }

  String getString(String key) {
    return _data[key] as String;
  }

  Array getArray(String key) {
    return _data[key] as Array;
  }

  Dictionary getDictionary(String key) {
    return _data[key] as Dictionary;
  }

  dynamic getValue(String key) {
    return _data[key];
  }

  dynamic _clone(dynamic obj) {
    if (obj is List) {
      return obj.map((e) => _clone(e)).toList();
    } else if (obj is Map<String, dynamic>) {
      return obj.map((k, v) => MapEntry(k, _clone(v)));
    } else {
      return obj;
    }
  }

  Map<String, dynamic> toMap() {
    return _clone(_data);
  }

  MutableDocument toMutable() {
    return MutableDocument.idAndData(_id, _data);
  }
}

class MutableDocument extends Document {
  MutableDocument() : super._() {
    _data = <String, dynamic>{};
    _id = Uuid().v4();
  }

  MutableDocument.id(String id) : super._() {
    _data = <String, dynamic>{};
    _id = id;
  }

  MutableDocument.data(Map<String, dynamic> data) : super._() {
    _data = _clone(data);
    _id = Uuid().v4();
  }

  MutableDocument.idAndData(String id, Map<String, dynamic> data) : super._() {
    _data = _clone(data);
    _id = id;
  }

  MutableDocument setValue(String key, dynamic value) {
    _data[key] = value;
    return this;
  }
}
