import 'package:intl/intl.dart';

class Stage {

  int _id;
  int _size;
  String _name;
  int _parameter;
  bool _lock;

  Stage(this._size, this._name, this._parameter, this._lock);

  Stage.withId(this._id, this._size, this._name, this._parameter, this._lock);

  int get id => _id;

  int get size => _size;

  String get name => _name;

  int get parameter => _parameter;

  bool get lock => _lock;

  set size(int newSize) {
    print(newSize);
    this._size = newSize;
  }

  set name(String newName) {
    this._name = newName;
  }

  set parameter(int newParameter) {
    this._parameter = newParameter;
  }

  set lock(bool newLock) {
    this._lock = newLock;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {};

    map['id'] = _id;
    map['size'] = _size;
    map['name'] = _name;
    map['parameter'] = _parameter;
    map['lock'] = _lock.toString();
    return map;
  }

// MapオブジェクトからCalendarオブジェクトを抽出する
  Stage.fromMapObject(Map<String, dynamic> map) {
    // print(map);
    this._id = map['id'];
    this._size = map['size'];
    this._name = map['name'];
    this._parameter = map['parameter'];
    this._lock = map['lock'] == "true" ? true:false;
  }
}
