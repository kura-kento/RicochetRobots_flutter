import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ricochetrobotsapp/screen/rabking_page.dart';
import 'package:ricochetrobotsapp/screen/top_page.dart';
import 'package:ricochetrobotsapp/stages/random_stage.dart';
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

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Container(
      color: Colors.grey[400],
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            color: Colors.black87,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.all(20.0),
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey,width: 1.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              padding: EdgeInsets.all(10.0),
                              child: Text("TimeAttack",style: TextStyle(color: Colors.black,fontSize: 20),)
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width-100,
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text("NAME：",
                                    textScaleFactor: 1.5,
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
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 4.0),
                                child: RaisedButton(
                                  child: Text("RANKING"),
                                  color: Colors.white,
                                  shape: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
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
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 4.0, right: 8.0),
                                child: RaisedButton(
                                  child: Text("START"),
                                  color: Colors.white,
                                  shape: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
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
                                ),
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
          ),
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
