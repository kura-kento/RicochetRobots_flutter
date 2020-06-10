import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ricochetrobotsapp/models/ranking.dart';
import 'package:ricochetrobotsapp/utils/database_help_ranking.dart';
import 'package:ricochetrobotsapp/utils/utils.dart';

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {

  DatabaseHelperRanking databaseHelperRanking =  DatabaseHelperRanking();
  List<Ranking> rankingList = List<Ranking>();

  @override
  void initState() {
    rankingData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.all(10.0),
          height: 500,
          width: 300,
          child: ListView.builder(
              itemBuilder: (context, index) {
                return ranking100(index);
              },
          itemCount: 100,),
        ),
      ),
    );
  }

  Future<void> rankingData() async{
    rankingList = await databaseHelperRanking.getRankingList();

    setState(() {});
  }
  Widget ranking100(index){
      return Row(
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
      );

  }
}
