import 'package:flutter/material.dart';
import 'package:ricochetrobotsapp/screen/top_page.dart';
import 'package:ricochetrobotsapp/utils/database_help.dart';
import 'package:ricochetrobotsapp/utils/shared_prefs.dart';
import 'package:ricochetrobotsapp/utils/sounds.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      home: FutureBuilder(
        builder: (BuildContext context ,AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            return snapshot.data;
          }else{
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
        future: setting(),
      )
    );
  }
  Future<Widget> setting()async{
    await SharedPrefs.setInstance();
//    final SoundManager bgmManager = SoundManager();
//    bgmManager.playLocal('Blue_Moon_2.mp3');
    DatabaseHelper.db = await DatabaseHelper.initializeDatabase();
    return TopPage();
  }
}
