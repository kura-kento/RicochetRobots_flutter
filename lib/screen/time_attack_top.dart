import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ricochetrobotsapp/screen/rabking_page.dart';
import 'package:ricochetrobotsapp/screen/top-page.dart';
import 'package:ricochetrobotsapp/stages/random_stage.dart';
import 'package:ricochetrobotsapp/utils/admob.dart';
import 'package:ricochetrobotsapp/utils/admob_service.dart';
import 'package:ricochetrobotsapp/utils/page_animation.dart';
import 'package:ricochetrobotsapp/utils/shared_prefs.dart';
import 'package:ricochetrobotsapp/utils/sounds.dart';

class TimeAttackTop extends StatefulWidget {
  @override
  _TimeAttackTopState createState() => _TimeAttackTopState();
}

class _TimeAttackTopState extends State<TimeAttackTop> {
  TextEditingController nameController = TextEditingController();
  final SoundManager soundManager = SoundManager();
  TextStyle textStyle = TextStyle(color: Colors.white);

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
                resizeToAvoidBottomInset: false,
                body: Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/wood.png"),
                            fit: BoxFit.cover
                        )
                    ),
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    margin: EdgeInsets.all(20.0),
                                    width: 400,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage("assets/images/tree_light_dark.png"),
                                          fit: BoxFit.cover
                                      ),
                                      border: Border.all(color: Colors.black,width: 1.0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text("TimeAttack",style: TextStyle(color: Colors.white,fontSize: 20),)
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width-100,
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text("NAME：",
                                                  textScaleFactor: 1.5, style: TextStyle(color: Colors.white)
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  height: 40,
                                                  child: TextField(
                                                    onChanged: _handleText,
                                                    onTap: (){
                                                      nameController.text = SharedPrefs.getName();
                                                    },
                                                    controller: nameController,
                                                    style: textStyle,
                                                    decoration: InputDecoration(
                                                        labelText: '${SharedPrefs.getName()}',
                                                        labelStyle: textStyle,
                                                        border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(5.0)
                                                        )
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                                margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 8.0, right: 4.0),
                                                decoration: BoxDecoration(
                                                  border:  Border.all(color: Colors.black54,width: 2.0),
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/images/tree_light_dark.png"),
                                                      fit: BoxFit.cover),
                                                ),
                                                child: FlatButton(
                                                  onPressed: () {
                                                    soundManager.playLocal('select.mp3');
                                                    Navigator.push(
                                                      context,
                                                      SlidePageRoute(
                                                        page: RankingPage(),
                                                        settings: RouteSettings(),
                                                      ),
                                                    );
                                                  },
                                                  child: Text("RANKING", style: TextStyle(fontSize:20,color: Colors.white),),
                                                )),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                                  margin: EdgeInsets.only(top:10.0,bottom:10.0,left: 8.0, right: 8.0),
                                                  decoration: BoxDecoration(
                                                      border:  Border.all(color: Colors.black54,width: 2.0),
                                                      borderRadius: BorderRadius.circular(10),
                                                    image: DecorationImage(
                                                        image: AssetImage("assets/images/tree_light_dark.png"),
                                                        fit: BoxFit.cover
                                                    ),
                                                  ),
                                                  child:FlatButton(
                                                    onPressed: () {
                                                      soundManager.playLocal('select.mp3');
                                                      Navigator.push(
                                                        context,
                                                        SlidePageRoute(
                                                          page: RandomStage(),
                                                          settings: RouteSettings(),
                                                        ),
                                                      );
                                                    },
                                                    child: Text("START",style: TextStyle(fontSize:20,color: Colors.white),),
                                                  )
                                              ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    ),
                                  ),
                                IconButton(
                                  iconSize: 40,
                                  icon:Icon(
                                      Icons.clear,
                                      color: Colors.white
                                  ),
                                  onPressed: (){
                                    soundManager.playLocal('cancel.mp3');
                                    Navigator.push(
                                      context,
                                      SlidePageRoute(
                                        page: TopPage(),
                                        settings: RouteSettings(name: '/stage_builder',),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AdMobService().admobBanner()
          ],
        ),
      ),
    );
  }

  void _handleText(String e) {
    setState(() {
      SharedPrefs.setName(e);
    });
  }
}
