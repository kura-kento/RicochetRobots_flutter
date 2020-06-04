import 'package:flutter/material.dart';
import 'package:ricochetrobotsapp/screen/stage_select.dart';
import 'package:ricochetrobotsapp/utils/page_animation.dart';
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
            Container(height: 400,),
            IconButton(
              icon: Icon(Icons.apps),
              onPressed: (){
                soundManagerSelect.playLocal('start.mp3');
                Navigator.push(
                  context,
                  SlidePageRoute(
                    page: StageSelect(),
                    settings: RouteSettings(name: '/stage_builder',),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: (){
                soundManagerSelect.playLocal('start.mp3');
                Navigator.push(
                  context,
                  SlidePageRoute(
                    page: StageSelect(),
                    settings: RouteSettings(name: '/stage_builder',),
                  ),
                );
              },
            )
          ],
        ),
      )
    );
  }
}

