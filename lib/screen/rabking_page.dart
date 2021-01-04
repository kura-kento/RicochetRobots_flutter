import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ricochetrobotsapp/models/ranking.dart';
import 'package:ricochetrobotsapp/screen/time_attack_top.dart';
import 'package:ricochetrobotsapp/utils/admob.dart';
import 'package:ricochetrobotsapp/utils/database_help_ranking.dart';
import 'package:ricochetrobotsapp/utils/page_animation.dart';
import 'package:ricochetrobotsapp/utils/sounds.dart';
import 'package:ricochetrobotsapp/utils/utils.dart';

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {

  DatabaseHelperRanking databaseHelperRanking =  DatabaseHelperRanking();
  List<Ranking> rankingList = List<Ranking>();
  final SoundManager soundManager = SoundManager();

  @override
  void initState() {
    rankingData();
    super.initState();
  }
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage("assets/images/tree_dark.png"),
                                        fit: BoxFit.cover
                                    ),
                                    border: Border.all(color: Colors.white,width: 1.0),
                                    borderRadius:  BorderRadius.circular(15.0)
                                ),
                                padding: EdgeInsets.all(10.0),
                                height: (MediaQuery.of(context).size.width),
                                width: (MediaQuery.of(context).size.width)*0.8,
                                child: Column(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.only(bottom:6.0),
                                        child: Text("Ranking",style: TextStyle(color: Colors.white,fontSize: 20),)),
                                    Expanded(
                                      child: ListView.builder(
                                        itemBuilder: (context, index) {
                                          return ranking100(index);
                                        },
                                        itemCount: 100,),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                        page: TimeAttackTop(),
                                        settings: RouteSettings(name: '/stage_builder',),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],

                  ),
                ),
              ),
            ),
            AdMob.banner()
          ],
        ),
      ),
    );
  }

  Future<void> rankingData() async{
    rankingList = await databaseHelperRanking.getRankingList();

    setState(() {});
  }
  Widget ranking100(index){
      return Container(
        color: index%2 == 0 ? Colors.grey[300]:Colors.white,
        child: Row(
          children: [
            Container(
                width: 30,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Utils.intWidget((index+1).toString(),3)
                )
            ),
            Text(":"),
            Container(
              //一番大きい数字に合わせる。
                width: 30,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: index < rankingList.length ? Utils.intWidget((rankingList[index].time/1000).toString().split(".")[0],3):Text(""))
              ),
            Text(index < rankingList.length ? ".":""),
            Container(
              //一番大きい数字に合わせる。
                width: 30,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: index < rankingList.length ? Utils.intWidget((rankingList[index].time/1000).toString().split(".")[1].padRight(3, "0"),3):Text(""))
            ),
            Container(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(index < rankingList.length ? "  ${rankingList[index].name}":"  ")
                )
            )
          ],
        ),
      );

  }
}
