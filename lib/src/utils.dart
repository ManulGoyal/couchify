part of couchify;

dynamic _clone(dynamic obj) {
  if (obj is Array) {
    return _clone(obj._data);
  } else if (obj is Dictionary) {
    return _clone(obj._data);
  } else if (obj is List) {
    return obj.map((e) => _clone(e)).toList();
  } else if (obj is Map<String, dynamic>) {
    return obj.map((k, v) => MapEntry(k, _clone(v)));
  } else if (obj is Map) {
    return Map<String, dynamic>.from(obj);
  } else if (obj is DateTime) {
    return obj.toUtc().toIso8601String();
  } else if (obj is num || obj is String || obj is bool || obj == null) {
    return obj;
  }
  throw Exception(
      "Unsupported data type in Couchbase object ${obj.runtimeType}");
}
