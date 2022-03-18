part of couchify;

class Document extends Iterable<String> {
  late final Map<String, dynamic> _data;
  late final String _id;

  Document._();
  Document._data(this._id, this._data);

  @override
  bool contains(Object? key) {
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

  bool? getBoolean(String key) {
    return _data[key] is bool ? _data[key] : null;
  }

  num? getNumber(String key) {
    return _data[key] is num ? _data[key] : null;
  }

  int? getInt(String key) {
    return _data[key] is int ? _data[key] : null;
  }

  int? getLong(String key) {
    return getInt(key);
  }

  double? getDouble(String key) {
    return _data[key] is double ? _data[key] : null;
  }

  double? getFloat(String key) {
    return getDouble(key);
  }

  DateTime? getDate(String key) {
    if (_data[key] is String) {
      try {
        var date = DateTime.parse(_data[key] as String);
        if (date.isUtc) {
          return date;
        } else {
          return null;
        }
      } on FormatException {
        return null;
      }
    }
    return null;
  }

  String? getString(String key) {
    return _data[key] is String ? _data[key] : null;
  }

  Array? getArray(String key) {
    return _data[key] is List ? Array._data(_data[key]) : null;
  }

  Dictionary? getDictionary(String key) {
    return _data[key] is Map<String, dynamic>
        ? Dictionary._data(_data[key])
        : null;
  }

  dynamic getValue(String key) {
    if (_data[key] is List) return getArray(key);
    if (_data[key] is Map<String, dynamic>) return getDictionary(key);
    return _data[key];
  }

  Map<String, dynamic> toMap() {
    return _clone(_data);
  }

  MutableDocument toMutable() {
    return MutableDocument.idAndData(_id, _data);
  }

  @override
  Iterator<String> get iterator => _data.keys.iterator;
}

class MutableDocument extends Document {
  MutableDocument() : super._() {
    _data = <String, dynamic>{};
    _id = const Uuid().v4();
  }

  MutableDocument.id(String id) : super._() {
    _data = <String, dynamic>{};
    _id = id;
  }

  MutableDocument.data(Map<String, dynamic> data) : super._() {
    _data = _clone(data);
    _id = const Uuid().v4();
  }

  MutableDocument.idAndData(String id, Map<String, dynamic> data) : super._() {
    _data = _clone(data);
    _id = id;
  }

  MutableDocument setBoolean(String key, bool value) {
    _data[key] = value;
    return this;
  }

  MutableDocument setNumber(String key, num value) {
    _data[key] = value;
    return this;
  }

  MutableDocument setInt(String key, int value) {
    _data[key] = value;
    return this;
  }

  MutableDocument setLong(String key, int value) {
    return setInt(key, value);
  }

  MutableDocument setDouble(String key, double value) {
    _data[key] = value;
    return this;
  }

  MutableDocument setFloat(String key, double value) {
    return setDouble(key, value);
  }

  MutableDocument setDate(String key, DateTime value) {
    _data[key] = value.toUtc().toIso8601String();
    return this;
  }

  MutableDocument setString(String key, String value) {
    _data[key] = value;
    return this;
  }

  MutableDocument setArray(String key, Array value) {
    _data[key] = _clone(value._data);
    return this;
  }

  MutableDocument setDictionary(String key, Dictionary value) {
    _data[key] = _clone(value._data);
    return this;
  }

  MutableDocument setValue(String key, dynamic value) {
    if (value is DateTime) return setDate(key, value);
    _data[key] = _clone(value);
    return this;
  }
}
