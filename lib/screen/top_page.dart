import 'package:flutter/material.dart';
import 'package:ricochetrobotsapp/screen/stage_select.dart';
import 'package:ricochetrobotsapp/stages/stage_builder.dart';
import 'package:ricochetrobotsapp/utils/page_animation.dart';
import 'package:ricochetrobotsapp/utils/shared_prefs.dart';
import 'package:ricochetrobotsapp/utils/sounds.dart';


class TopPage extends StatefulWidget {
  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  final SoundManager soundManagerSelect = SoundManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(height: 200,),
            Text("stage"+SharedPrefs.getStage().toString()),
            Container(height: 50,),
            IconButton(
              icon: Icon(Icons.play_arrow),
              iconSize: 40,
              onPressed: (){
                soundManagerSelect.playLocal('start.mp3');
                Navigator.push(
                  context,
                  SlidePageRoute(
                    page: StageBuilder(id: SharedPrefs.getStage()),
                    settings: RouteSettings(name: '/stage_builder',),
                  ),
                );
              },
            ),
            Container(height: 25,),
            IconButton(
              icon: Icon(Icons.apps),
              iconSize: 40,
              onPressed: (){
                soundManagerSelect.playLocal('select.mp3');
                Navigator.push(
                  context,
                  SlidePageRoute(
                    page: StageSelect(),
                    settings: RouteSettings(name: '/stage_builder',),
                  ),
                );
              },
            ),
          ],
        ),
      )
    );
  }
}

