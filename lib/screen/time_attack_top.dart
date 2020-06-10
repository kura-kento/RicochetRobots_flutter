import 'package:flutter/material.dart';
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
  final SoundManager soundManagerSelect = SoundManager();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Center(
          child: Container(
            margin:  const EdgeInsets.all(20.0),
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black,width: 1.0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                    border: Border.all(color: Colors.black,width: 1.0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                    child: IconButton(
                      icon:Icon(
                          Icons.home,
                          color: Colors.black
                      ),
                      onPressed: (){
                        //soundManager.playLocal('select.mp3');
                        Navigator.push(
                          context,
                          SlidePageRoute(
                            page: TopPage(),
                            settings: RouteSettings(name: '/stage_builder',),
                          ),
                        );
                      },
                    ),
                  ),
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
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding:  const EdgeInsets.only(left: 8.0,right: 4.0),
                        child: RaisedButton(
                          child: Text("RANKING"),
                          color: Colors.white,
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          onPressed: (){
                            soundManagerSelect.playLocal('select.mp3');
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
                        padding: const EdgeInsets.only(left: 4.0,right: 8.0),
                        child: RaisedButton(
                          child: Text("START"),
                          color: Colors.white,
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          onPressed: (){
                            soundManagerSelect.playLocal('select.mp3');
                            Navigator.push(
                              context,
                              SlidePageRoute(
                                page: RandomStage(id: 24),
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
