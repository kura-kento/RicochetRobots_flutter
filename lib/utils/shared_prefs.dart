import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {

  static final stage = 'stage';
  static final name = 'name';
  static final loginCount = 'loginCount';

  static SharedPreferences _sharedPreferences;

  static Future<void> setInstance() async {
    if (null != _sharedPreferences) return;
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setStage(int value) => _sharedPreferences.setInt(stage, value);
  static int getStage() => _sharedPreferences.getInt(stage) ?? 1;

  //static Future<void> removeUnit() => _sharedPreferences.remove(unit);

  static Future<bool> setName(String value) => _sharedPreferences.setString(name, value);
  static String getName() => _sharedPreferences.getString(name) ?? "player";

  static Future<bool> setLoginCount(int value) => _sharedPreferences.setInt(loginCount, value);
  static int getLoginCount() => _sharedPreferences.getInt(loginCount) ?? 0;
}
