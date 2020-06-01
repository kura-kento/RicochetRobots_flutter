import 'package:ricochetrobotsapp/models/stage.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database db;                // Singleton Database

  static String tableName = 'stage';
  static String colId = 'id';
  static String colSize = 'size';
  static String colName = 'name';
  static String colParameter = 'parameter';
  static String colRobots = 'robots';
  static String colLock = 'lock';


  DatabaseHelper._createInstance(); // DatabaseHelperのインスタンスを作成するための名前付きコンストラクタ

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // これは1回だけ実行されます。
    }
    return _databaseHelper;
  }

  Database get database{
    return db;
  }

  static Future<Database> initializeDatabase() async {
    // データベースを保存するためのAndroidとiOSの両方のディレクトリパスを取得する
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/stage.db';

    // Open/指定されたパスにデータベースを作成する
    var stagesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return stagesDatabase;
  }

  static void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colSize INTEGER,'
        '$colName TEXT, $colParameter TEXT, $colRobots TEXT, $colLock TEXT)');
    await db.insert(tableName,Stage(5,"stage1",[[2,2,210],[3,3,231],[1,3,14]],[[1,1]],false).toMap());
    await db.insert(tableName,Stage(5,"stage1",[[1,4,770],[1,3,14]],[[1,1]],true).toMap());
    await db.insert(tableName,Stage(5,"stage2",[[2,2,210],[3,3,231]],[[4,0],[4,1]],true).toMap());
    await db.insert(tableName,Stage(5,"stage2",[[2,4,462]],[[4,0],[4,1]],true).toMap());
    await db.insert(tableName,Stage(5,"stage2",[[0,3,330],[1,1,21],[4,1,7],[1,4,3],[2,3,3]],[[0,0],[0,1]],true).toMap());
    await db.insert(tableName,Stage(5,"stage2",[[1,3,11]],[[4,0],[4,1],[4,2]],true).toMap());
    await db.insert(tableName,Stage(5,"stage2",[[0,3,770],[1,2,21],[4,1,7]],[[4,1],[4,4]],true).toMap());
    await db.insert(tableName,Stage(5,"stage2",[[0,2,210],[2,1,210],[4,2,1155]],[[4,0],[4,1]],true).toMap());
    await db.insert(tableName,Stage(6,"stage3",[[2,3,77],[3,0,3],[2,2,14],[3,5,6],[5,3,7],[0,2,7]],[[3,2],[4,1]],true).toMap());
    await db.insert(tableName,Stage(7,"stage3",[[3,4,10],[2,2,210],[1,1,231]],[[4,0],[4,1]],true).toMap());
    await db.insert(tableName,Stage(7,"stage4",[[4,5,10],[2,2,210],[1,1,231]],[[4,0],[4,1]],true).toMap());

  }

  // Fetch Operation: データベースからすべてのカレンダーオブジェクトを取得します
  Future<List<Map<String, dynamic>>> getStageMapList() async {
    var result = await this.database.query(tableName, orderBy: '$colId ASC');
    return result;
  }

  // Fetch Operation: データベースからすべてのカレンダーオブジェクトを取得します
  Future<List<Map<String, dynamic>>> getStageMap() async {
    var result = await this.database.query(tableName, orderBy: '$colId ASC');
    return result;
  }

//挿入　更新　削除
  // Insert Operation: Insert a Note object to database
  Future<int> insertStage(Stage stage) async {
    var result = await this.database.insert(tableName, stage.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateStage(Stage stage) async {
    var result = await this.database.update(tableName, stage.toMap(), where: '$colId = ?', whereArgs: [stage.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteStage(int id) async {
    int result = await this.database.rawDelete('DELETE FROM $tableName WHERE $colId = $id');
    return result;
  }

  //データベース内のNoteオブジェクトの数を取得します
  Future<int> getCount() async {
    //rawQuery括弧ないにSQL文が使える。
    List<Map<String, dynamic>> x = await this.database.rawQuery('SELECT COUNT (*) from $tableName');
    //firstIntValueはlist型からint型に変更している。
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // 'Map List' [List <Map>]を取得し、それを 'Calendar List' [List <Note>]に変換します
  Future<List<Stage>> getStageList() async {
    //全てのデータを取得
    var stageMapList = await getStageMapList(); // Get 'Map List' from database
    int count = stageMapList.length;         // Count the number of map entries in db table

    List<Stage> stageList = List<Stage>();
    for (int i = 0; i < count; i++) {
      stageList.add(Stage.fromMapObject(stageMapList[i]));
    }
    return stageList;
  }
  Future<Map<String, dynamic>> getNextStageMap(id) async {
    List<Map<String, dynamic>> x = await this.database.rawQuery('SELECT COUNT (*) from $tableName');
    int count = Sqflite.firstIntValue(x);
    var result = await this.database.query(tableName,where: 'id = ? ',whereArgs: ['${id < count ? id+1:count}'], orderBy: '$colId ASC');
    return result[0];
  }
//次ののデータを取得
  Future<Stage> getNextStage(id) async {

    var stageNext = await getNextStageMap(id); // Get 'Map List' from database
    return Stage.fromMapObject(stageNext);
  }
}