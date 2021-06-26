import 'package:flutter/material.dart';
import 'package:ricochetrobotsapp/screen/stage_select.dart';
import 'package:ricochetrobotsapp/screen/time_attack_top.dart';
import 'package:ricochetrobotsapp/stages/stage_builder.dart';
import 'package:ricochetrobotsapp/utils/app.dart';
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
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Scaffold(
                body: Container(
                  // color: App.background,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(icon: Icon(Icons.brightness_1, color: App.redColor, size: 18,), onPressed: null),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(icon: Icon(Icons.brightness_1, color: App.blueColor, size: 18,), onPressed: null),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: IconButton(icon: Icon(Icons.brightness_1, color: App.greenColor, size: 18,), onPressed: null),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(icon: Icon(Icons.brightness_1, color: App.yellowColor, size: 18,), onPressed: null),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.all(4.0),
                            width: 250,
                            height: 40+16.0,
                            color: App.primaryColor,
                            child: Center(
                              child: Text(
                                "STAGE " + SharedPrefs.getStage().toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.all(4.0),
                                width: 250 - 40 - 24.0,
                                color: App.primaryColor,
                                child: IconButton(
                                  icon: Icon(Icons.play_arrow,color: Color(0xFF663300)),
                                  iconSize: 40,
                                  onPressed: () {
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
                              ),
                              Container(
                                margin: EdgeInsets.all(4.0),
                                color: App.primaryColor,
                                child: IconButton(
                                  icon: Icon(Icons.apps,color: Color(0xFF663300)),
                                  iconSize: 40,
                                  onPressed: (){
                                    soundManagerSelect.playLocal('select.mp3');
                                    Navigator.push(
                                      context,
                                      SlidePageRoute(
                                        page: StageSelect(),
                                        settings: RouteSettings(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ),
            ),
         //   AdMob.banner()
          ],
        ),
      ),
    );
  }
}

