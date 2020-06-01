
import 'dart:convert';

class Stage {

  int _id;
  int _size;
  String _name;
  List<List<int>> _parameter;
  List<List<int>> _robots;
  bool _lock;

  Stage(this._size, this._name, this._parameter,this._robots, this._lock);

  Stage.withId(this._id, this._size, this._name, this._parameter,this._robots, this._lock);

  int get id => _id;

  int get size => _size;

  String get name => _name;

  List<List<int>> get parameter => _parameter;

  List<List<int>> get robots => _robots;

  bool get lock => _lock;

  set size(int newSize) {
    print(newSize);
    this._size = newSize;
  }

  set name(String newName) {
    this._name = newName;
  }

  set parameter(List<List<int>> newParameter) {
    this._parameter = newParameter;
  }

  set robots(List<List<int>> newRobots) {
    this._robots = newRobots;
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
    map['parameter'] = json.encode(_parameter);
    map['robots'] = json.encode(_robots);
    map['lock'] = _lock.toString();
    return map;
  }

// MapオブジェクトからCalendarオブジェクトを抽出する
  Stage.fromMapObject(Map<String, dynamic> map) {
//     print(map);
    this._id = map['id'];
    this._size = map['size'];
    this._name = map['name'];
    List<List<int>> parameterList=[];
    json.decode(map['parameter']).forEach((value) => parameterList.add(value.cast<int>()));
    this._parameter = parameterList;
    List<List<int>> robotsList=[];
    json.decode(map['robots']).forEach((value) => robotsList.add(value.cast<int>()));
    this._robots = robotsList;
    this._lock = map['lock'] == "true" ? true:false;

  }

}
