import 'package:flutter/material.dart';
import 'package:ricochetrobotsapp/screen/stage_select.dart';
import 'package:ricochetrobotsapp/screen/time_attack_top.dart';
import 'package:ricochetrobotsapp/stages/stage_builder.dart';
import 'package:ricochetrobotsapp/utils/admob.dart';
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
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/wood.png"),
              fit: BoxFit.cover
          )
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/wood.png"),
                          fit: BoxFit.cover
                      )
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(height: 200,),
                            Container(
                              padding: EdgeInsets.only(top:5.0,bottom:5.0,left:5.0,right:5.0),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/btn03_01_light.png"),
                                    // fit: BoxFit.cover
                                  )
                              ),
                              child: Center(child: Text("STAGE"+SharedPrefs.getStage().toString(),style: TextStyle(fontSize:20,color: Colors.white))),
                            ),
                            Container(height: 50,),
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/images/btn03_04_light.png"),
                                      fit: BoxFit.cover
                                  )
                              ),
                              child: IconButton(
                                icon: Icon(Icons.play_arrow,color: Color(0xFF663300)),
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
                            ),
                            Container(height: 25,),
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/images/btn03_04_light.png"),
                                      fit: BoxFit.cover
                                  )
                              ),
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
                            Container(height: 25,),
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/images/btn03_04_light.png"),
                                      fit: BoxFit.cover
                                  )
                              ),
                              child: IconButton(
                                icon: Icon(Icons.timer,color: Color(0xFF663300),),
                                iconSize: 40,
                                onPressed: (){
                                  soundManagerSelect.playLocal('select.mp3');
                                  Navigator.push(
                                    context,
                                    SlidePageRoute(
                                      page: TimeAttackTop(),
                                      settings: RouteSettings(),
                                    ),
                                  );
                                },
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ),
            AdMob.banner()
          ],
        ),
      ),
    );
  }
}

