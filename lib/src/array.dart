part of couchify;

class Array extends Iterable {
  late final List _data;

  Array._();
  Array._data(this._data);

  int count() {
    return _data.length;
  }

  bool? getBoolean(int index) {
    return _data[index] is bool ? _data[index] : null;
  }

  num? getNumber(int index) {
    return _data[index] is num ? _data[index] : null;
  }

  int? getInt(int index) {
    return _data[index] is int ? _data[index] : null;
  }

  int? getLong(int index) {
    return getInt(index);
  }

  double? getDouble(int index) {
    return _data[index] is double ? _data[index] : null;
  }

  double? getFloat(int index) {
    return getDouble(index);
  }

  DateTime? getDate(int index) {
    if (_data[index] is String) {
      try {
        var date = DateTime.parse(_data[index] as String);
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

  String? getString(int index) {
    return _data[index] is String ? _data[index] : null;
  }

  Array? getArray(int index) {
    return _data[index] is List ? Array._data(_data[index]) : null;
  }

  Dictionary? getDictionary(int index) {
    return _data[index] is Map<String, dynamic>
        ? Dictionary._data(_data[index])
        : null;
  }

  dynamic getValue(int index) {
    if (_data[index] is List) return getArray(index);
    if (_data[index] is Map<String, dynamic>) return getDictionary(index);
    return _data[index];
  }

  @override
  List toList({bool growable = true}) {
    return _clone(_data);
  }

  MutableArray toMutable() {
    return MutableArray.data(_data);
  }

  @override
  Iterator get iterator => _ArrayIterator(this);
}

class MutableArray extends Array {
  MutableArray() : super._() {
    _data = <dynamic>[];
  }

  MutableArray.data(List data) : super._() {
    _data = _clone(data);
  }

  MutableArray addBoolean(bool value) {
    _data.add(value);
    return this;
  }

  MutableArray addNumber(num value) {
    _data.add(value);
    return this;
  }

  MutableArray addInt(int value) {
    _data.add(value);
    return this;
  }

  MutableArray addLong(int value) {
    return addInt(value);
  }

  MutableArray addDouble(double value) {
    _data.add(value);
    return this;
  }

  MutableArray addFloat(double value) {
    return addDouble(value);
  }

  MutableArray addDate(DateTime value) {
    _data.add(value.toUtc().toIso8601String());
    return this;
  }

  MutableArray addString(String value) {
    _data.add(value);
    return this;
  }

  MutableArray addArray(Array value) {
    _data.add(_clone(value._data));
    return this;
  }

  MutableArray addDictionary(Dictionary value) {
    _data.add(_clone(value._data));
    return this;
  }

  MutableArray addValue(dynamic value) {
    if (value is DateTime) return addDate(value);
    _data.add(_clone(value));
    return this;
  }

  MutableArray setBoolean(int index, bool value) {
    _data[index] = value;
    return this;
  }

  MutableArray setNumber(int index, num value) {
    _data[index] = value;
    return this;
  }

  MutableArray setInt(int index, int value) {
    _data[index] = value;
    return this;
  }

  MutableArray setLong(int index, int value) {
    return setInt(index, value);
  }

  MutableArray setDouble(int index, double value) {
    _data[index] = value;
    return this;
  }

  MutableArray setFloat(int index, double value) {
    return setDouble(index, value);
  }

  MutableArray setDate(int index, DateTime value) {
    _data[index] = value.toUtc().toIso8601String();
    return this;
  }

  MutableArray setString(int index, String value) {
    _data[index] = value;
    return this;
  }

  MutableArray setArray(int index, Array value) {
    _data[index] = _clone(value._data);
    return this;
  }

  MutableArray setDictionary(int index, Dictionary value) {
    _data[index] = _clone(value._data);
    return this;
  }

  MutableArray setValue(int index, dynamic value) {
    if (value is DateTime) return setDate(index, value);
    _data[index] = _clone(value);
    return this;
  }

  MutableArray insertBoolean(int index, bool value) {
    _data.insert(index, value);
    return this;
  }

  MutableArray insertNumber(int index, num value) {
    _data.insert(index, value);
    return this;
  }

  MutableArray insertInt(int index, int value) {
    _data.insert(index, value);
    return this;
  }

  MutableArray insertLong(int index, int value) {
    return insertInt(index, value);
  }

  MutableArray insertDouble(int index, double value) {
    _data.insert(index, value);
    return this;
  }

  MutableArray insertFloat(int index, double value) {
    return insertDouble(index, value);
  }

  MutableArray insertDate(int index, DateTime value) {
    _data.insert(index, value.toUtc().toIso8601String());
    return this;
  }

  MutableArray insertString(int index, String value) {
    _data.insert(index, value);
    return this;
  }

  MutableArray insertArray(int index, Array value) {
    _data.insert(index, _clone(value._data));
    return this;
  }

  MutableArray insertDictionary(int index, Dictionary value) {
    _data.insert(index, _clone(value._data));
    return this;
  }

  MutableArray insertValue(int index, dynamic value) {
    if (value is DateTime) return insertDate(index, value);
    _data.insert(index, _clone(value));
    return this;
  }
}
