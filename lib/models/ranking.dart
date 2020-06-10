
class Ranking {

  int _id;
  String _name;
  int _time;

  Ranking(this._name, this._time);
  Ranking.withId(this._id,this._name, this._time);

  int get id => _id;

  String get name => _name;

  int get time => _time;


  set name(String newName) {
    this._name = newName;
  }

  set time(int newTime) {
    this._time = newTime;
  }



  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['id'] = _id;
    map['name'] = _name;
    map['time'] = _time;
    return map;
  }

// MapオブジェクトからCalendarオブジェクトを抽出する
  Ranking.fromMapObject(Map<String, dynamic> map) {
     print(map);
    this._id = map['id'];
    this._name = map['name'];
    this._time = map['time'];
  }

}
