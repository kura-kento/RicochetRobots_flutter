import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {

  static final stage = 'stage';

  static SharedPreferences _sharedPreferences;

  static Future<void> setInstance() async {
    if (null != _sharedPreferences) return;
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setStage(int value) => _sharedPreferences.setInt(stage, value);
  static int getStage() => _sharedPreferences.getInt(stage) ?? 1;
  //static Future<void> removeUnit() => _sharedPreferences.remove(unit);

}
