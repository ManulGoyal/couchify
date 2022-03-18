part of couchify;

class _ArrayIterator implements Iterator {
  final Array _array;
  int _index = -1;

  _ArrayIterator(this._array);

  @override
  dynamic get current => _array.getValue(_index);

  @override
  bool moveNext() {
    if (_index == _array._data.length - 1) return false;
    _index++;
    return true;
  }
}
