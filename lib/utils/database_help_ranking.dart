import 'package:ricochetrobotsapp/models/ranking.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelperRanking {

  static DatabaseHelperRanking _databaseHelper;    // Singleton DatabaseHelper
  static Database db;                // Singleton Database

  static String tableName = 'ranking';
  static String colId = 'id';
  static String colName = 'name';
  static String colTime = 'time';


  DatabaseHelperRanking._createInstance(); // DatabaseHelperのインスタンスを作成するための名前付きコンストラクタ

  factory DatabaseHelperRanking() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelperRanking._createInstance(); // これは1回だけ実行されます。
    }
    return _databaseHelper;
  }

  Database get database{
    return db;
  }

  static Future<Database> initializeDatabase() async {
    // データベースを保存するためのAndroidとiOSの両方のディレクトリパスを取得する
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/ranking.db';

    // Open/指定されたパスにデータベースを作成する
    var rankingsDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return rankingsDatabase;
  }

  static void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colTime INTEGER)');
  }

  // Fetch Operation: データベースからすべてのカレンダーオブジェクトを取得します
  Future<List<Map<String, dynamic>>> getRankingMapList() async {
    var result = await this.database.query(tableName, orderBy:'$colTime ASC' );
    return result;
  }

  // Fetch Operation: データベースからすべてのカレンダーオブジェクトを取得します
  Future<List<Map<String, dynamic>>> getRankingMap() async {
    var result = await this.database.query(tableName, orderBy: '$colId ASC');
    return result;
  }

//挿入　更新　削除
  // Insert Operation: Insert a Note object to database
  Future<int> insertRanking(Ranking ranking) async {
    var result = await this.database.insert(tableName, ranking.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateRanking(Ranking ranking) async {
    var result = await this.database.update(tableName, ranking.toMap(), where: '$colId = ?', whereArgs: [ranking.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteRanking(int id) async {
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
  Future<List<Ranking>> getRankingList() async {
    //全てのデータを取得
    var rankingMapList = await getRankingMapList(); // Get 'Map List' from database
    int count = rankingMapList.length;         // Count the number of map entries in db table

    List<Ranking> rankingList = List<Ranking>();
    for (int i = 0; i < count; i++) {
      rankingList.add(Ranking.fromMapObject(rankingMapList[i]));
    }
    return rankingList;
  }
  Future<Map<String, dynamic>> getSingleRankingMap(id) async {
    List<Map<String, dynamic>> x = await this.database.rawQuery('SELECT COUNT (*) from $tableName');
    int count = Sqflite.firstIntValue(x);
    var result = await this.database.query(tableName,where: 'id = ? ',whereArgs: [id < count ? id : count], orderBy: '$colId ASC');
    return result[0];
  }
//次ののデータを取得
  Future<Ranking> getSingleRanking(id) async {
    var ranking = await getSingleRankingMap(id); // Get 'Map List' from database
    return Ranking.fromMapObject(ranking);
  }
}