part of couchify;

class Result extends Iterable<String> {
  final Map<String, dynamic> _data;

  Result._(this._data);

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

  @override
  Iterator<String> get iterator => _data.keys.iterator;
}
