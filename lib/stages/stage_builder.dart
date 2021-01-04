import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store_listing/flutter_store_listing.dart';
import 'package:ricochetrobotsapp/models/stage.dart';
import 'package:ricochetrobotsapp/screen/stage_select.dart';
import 'package:ricochetrobotsapp/screen/top_page.dart';
import 'package:ricochetrobotsapp/utils/admob.dart';
import 'package:ricochetrobotsapp/utils/database_help.dart';
import 'package:ricochetrobotsapp/utils/page_animation.dart';
import 'package:ricochetrobotsapp/utils/shared_prefs.dart';
import 'package:ricochetrobotsapp/utils/sounds.dart';



class StageBuilder extends StatefulWidget {
  StageBuilder({Key key,this.id}) : super(key: key);
  final int id;
  @override
  _StageBuilderState createState() => _StageBuilderState();
}

class _StageBuilderState extends State<StageBuilder> {

  SoundManager soundManager = SoundManager();

  // int stageSize = 5;//5×5
  //2.0/(stageSize-1)
  bool isLoading = false;
  int stageSize = 10;
  List<int>  after = [0,0];
  List<List<int>> parameter;
  List<List<int>> robotList;
  Stopwatch s = Stopwatch();
  List<Map<String,dynamic>> robotsMap = List<Map<String,dynamic>>();

  DatabaseHelper databaseHelper = DatabaseHelper();
  Stage stageData;
  Color wallColors = Color(0xff888888);
  @override
  void initState(){
    dataInstall(widget.id);
    s.start();
    super.initState();
  }

  List parameterList(){
    List<List<int>> list =[];
    for(int i=0;i < stageSize;i++){
      List<int> listCache = [];
      for(int j=0;j < stageSize;j++){
        listCache.add(null);
      }
      list.add(listCache);
    }
    stageData.parameter.forEach((value) => list[value[0]][value[1]] = value[2]);
    return  list;
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
                          children: [
                              Center(
                                  child: Container(
                                      padding: EdgeInsets.only(top:25.0,bottom:28.0,left:20.0,right:20.0),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage("assets/images/btn03_01_light.png"),
                                          )
                                      ),
                                    child: Text("STAGE${widget.id}",style: TextStyle(fontSize:20,color: Colors.white),))
                              ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: iconButtons()
                            ),
                            Padding(padding: EdgeInsets.only(bottom:10.0),),
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Column(children: tiles(),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Stack(children: robot()),
                                ),

                                Text('')
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
  List<Widget> tiles(){
    List<Widget> _list = [];
    if(parameter!=null) {
      for (int i = 0; i < stageSize; i++) {
        List<Widget> a = [Container(height: 4.0, width: 4.0, color: Colors.white,)];
        List<Widget> _listCache = [Container(height: (MediaQuery.of(context).size.width - 10 - (4 * stageSize)) / stageSize, width: 4.0, color: wallColors,)];
        for (int j = 0; j < stageSize; j++) {
          _listCache.add(
                Container(
                      height: (MediaQuery.of(context).size.width - 10 - (4 * stageSize)) / stageSize,
                      width: (MediaQuery.of(context).size.width - 10 - (4 * stageSize)) / stageSize,
                      color: parameter[i][j] != null && parameter[i][j] % 11 == 0 ? Color(0xfff07783): parameter[i][j] != null && parameter[i][j] % 210 == 0 ? wallColors: Colors.grey[300],
//                      child: Text("${[i,j]}"),
                      child: Text(""),
                    ),
          );
          _listCache.add(
              Container(
                  height: (MediaQuery.of(context).size.width - 10 - (4 * stageSize)) / stageSize,
                  width: 4.0,
                  color: wallColor(i,j)
              )
          );
        }
        _list.add(Row(children: _listCache,));
        for (int j = 0; j < stageSize; j++) {
          a.add(
            Container(
                width: (MediaQuery.of(context).size.width - 10 - (4 * stageSize)) / stageSize,
                height: 4.0,
                color: wallColor2(i,j)
            )
          );
          a.add(
              Container(
                height: 4.0,
                width: 4.0,
                color: Colors.white,
              )
          );
        }
        if(i==stageSize-1){
          _list.insert(0,Row(children: a,));
        }
        _list.add(Row(children: a,));
      }
    }
    return _list;

  }
  Color wallColor(i,j){
    if(j == stageSize-1 ){
      return wallColors;
    }
    if(parameter[i][j] == null ){
    }else{
      if(parameter[i][j] % 7 == 0 && parameter[i][j] % 210 != 0){
        return wallColors;
      }
    }
    if(j+1 < stageSize && parameter[i][j+1] != null){
      if(parameter[i][j+1] % 5 == 0 && parameter[i][j+1] % 210 != 0){
        return wallColors;
      }
    }
    return Colors.white;
  }
  Color wallColor2(i,j){
    if(i == stageSize-1 ){
      return wallColors;
    }
    if(parameter[i][j] == null ){
    }else{
      if(parameter[i][j] % 3 == 0 && parameter[i][j] % 210 != 0){
        return wallColors;
      }
    }
    if(i+1 < stageSize && parameter[i+1][j] != null){
      if(parameter[i+1][j] % 2 == 0 && parameter[i+1][j] % 210 != 0){
        return wallColors;
      }
    }
    return Colors.white;
  }

  List<Widget>iconButtons(){
    List _icons = [Icons.refresh,Icons.apps,Icons.home];
    List _route = [StageBuilder(id: widget.id),StageSelect(),TopPage()];
    List<Widget> _cache=[];
    for(int i = 0;i < _icons.length; i++){
      _cache.add(
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/btn03_04_light.png"),
                  fit: BoxFit.cover
              )
          ),
          child: IconButton(
            icon:Icon(
                _icons[i],
                color: Color(0xFF663300)
            ),
            onPressed: (){
              soundManager.playLocal('select.mp3');
              Navigator.push(
                context,
                SlidePageRoute(
                  page: _route[i],
                  settings: RouteSettings(name: '/stage_builder',),
                ),
              );
            },
          ),
        ),
      );
    }
    return _cache;
  }
  List<Widget> robot(){
    List<Widget> _list = [Text('')];
    for(int mapIndex=0;mapIndex < robotsMap.length;mapIndex++){
      _list.add(
        GestureDetector(
          onVerticalDragUpdate: (detail) {
            if (detail.primaryDelta > 5 || detail.primaryDelta < -5){
              detail.primaryDelta > 5 ? bottomMove(mapIndex) : topMove(mapIndex);
              //ここに１秒くらい停止させる。
              moveProcess(mapIndex);
            }
          },
          onHorizontalDragUpdate: (detail) {
            if (detail.primaryDelta > 5 || detail.primaryDelta < -5) {
              detail.primaryDelta > 5 ? rightMove(mapIndex) : leftMove(mapIndex);
              //ここに１秒くらい停止させる。
              moveProcess(mapIndex);
            }
          },
          child: Container(
            height: (MediaQuery.of(context).size.width - 10),
            width: (MediaQuery.of(context).size.width - 10),
            child: AnimatedAlign(
              alignment: robotsMap[mapIndex]["alignment"],
              duration: Duration(milliseconds: 500),
              child: Container(
                margin: EdgeInsets.all(2.0+25.0/stageSize),
                width: (MediaQuery.of(context).size.width-50-10-(4*stageSize)) / stageSize,
                height: (MediaQuery.of(context).size.width-50-10-(4*stageSize)) / stageSize,
                decoration: BoxDecoration(
                    color: robotsMap[mapIndex]["color"],
                    borderRadius: BorderRadius.circular(100)),
              ),
              curve: Curves.easeInOut,
            ),
          ),
        ),
      );
    }
    return _list;
  }

  void topMove(mapIndex){
    after = robotsMap[mapIndex]["robot"];
    outside: for(int i = 0;i < stageSize ; i++){
      for(int index=0;index < robotsMap.length;index++){
        if(mapIndex == index){continue;}
        if(after[0] == robotsMap[index]["robot"][0] && after[1] == robotsMap[index]["robot"][1]){after[0] += 1; break outside;}
      }
      if(parameter[after[0]][after[1]] == null){

      }else if(parameter[after[0]][after[1]] % 3 == 0 ){
        if(i != 0) { after[0] += 1; break; }
      }else if(parameter[after[0]][after[1]] % 2 == 0 ){
        break;
      }
      if(after[0] == 0)break;
      after[0]+= -1;
    }
  }
  void bottomMove(mapIndex){
    after = robotsMap[mapIndex]["robot"];
    outside: for(int i = 0;i < stageSize ; i++){
      for(int index=0;index < robotsMap.length;index++){
        if(mapIndex == index){continue;}
        if(after[0] == robotsMap[index]["robot"][0] && after[1] == robotsMap[index]["robot"][1]){after[0] += -1; break outside;}
      }
      if(parameter[after[0]][after[1]] == null){

      }else if(parameter[after[0]][after[1]] % 2 == 0){
        if(i != 0) { after[0] += -1; break; }
      }else if(parameter[after[0]][after[1]] % 3 == 0){
        break;
      }
      if(after[0] == stageSize-1)break;
      after[0]+= 1;
    }
  }
  void rightMove(mapIndex){
    after = robotsMap[mapIndex]["robot"];
    outside: for(int i = 0;i < stageSize ; i++){
      for(int index=0;index < robotsMap.length;index++){
        if(mapIndex == index){continue;}
        if(after[0] == robotsMap[index]["robot"][0] && after[1] == robotsMap[index]["robot"][1]){after[1] += -1; break outside;}
      }
      if(parameter[after[0]][after[1]] == null){

      }else if(parameter[after[0]][after[1]] % 5 == 0){
        if(i != 0) { after[1] += -1; break; }
      }else if(parameter[after[0]][after[1]] % 7 == 0){
        break;
      }
      if(after[1] == stageSize-1)break;
      after[1]+= 1;
    }
  }
  void leftMove(mapIndex){
    after = robotsMap[mapIndex]["robot"];
    outside: for(int i = 0;i < stageSize ; i++){
      for(int index=0;index < robotsMap.length;index++){
        if(mapIndex == index){continue;}
        if(after[0] == robotsMap[index]["robot"][0] && after[1] == robotsMap[index]["robot"][1]){after[1] += 1; break outside;}
      }
      if(parameter[after[0]][after[1]] == null){

      }else if(parameter[after[0]][after[1]] % 7 == 0){
        if(i != 0) { after[1] += 1; break; }
      }else if(parameter[after[0]][after[1]] % 5 == 0){
        break;
      }
      if(after[1] == 0)break;
      after[1]+= -1;
    }
  }

  moveProcess(mapIndex) {
    isLoading = true;
    soundManager.playLocal('move.mp3');
    robotsMap[mapIndex]["alignment"] = Alignment(-1.0 + after[1] * (2.0/(stageSize-1)),-1.0+ after[0] * (2.0/(stageSize-1)));
    setState(() {});
    if(parameter[after[0]][after[1]] == null){

    }else if(parameter[after[0]][after[1]]% 11 == 0 && mapIndex == 0){
      SharedPrefs.setLoginCount(SharedPrefs.getLoginCount()+1);
      if(Platform.isIOS && SharedPrefs.getLoginCount() % 20 == 0){
        FlutterStoreListing().launchRequestReview(onlyNative: true);
      }
      soundManager.playLocal('goal.mp3');
      s.stop();
      unlock();
      //変更予定
      SharedPrefs.setStage(widget.id+1);
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
              title: Text("CLEAR"),
            content: Text("TIME ${s.elapsed.toString().substring(2, 11)}"),
            actions: <Widget>[
              // ボタン領域
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/btn03_04_light.png"),
                      fit: BoxFit.cover
                    ),
                ),
                child: IconButton(
                  icon: Icon(Icons.reply),
                  iconSize: 25,
                  color: Color(0xFF663300),
                  onPressed: (){
                    soundManager.playLocal('select.mp3');
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/btn03_04_light.png"),
                      fit: BoxFit.cover
                  ),
                ),
                child: IconButton(
                  icon: Icon(Icons.play_arrow),
                  iconSize: 25,
                  color: Color(0xFF663300),
                  onPressed: (){
                    soundManager.playLocal('select.mp3');
                    Navigator.push(
                      context,
                      SlidePageRoute(
                        page: StageBuilder(id: widget.id+1),
                        settings: RouteSettings(name: '/stage_builder',),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void robotsListMap(){
    List<Color> colors = [Color(0xfff07783),Color(0xff75A9FF),Color(0xffB3DC86),Color(0xffFFD877)];
    for(int i=0;i<stageData.robots.length;i++){
      robotsMap.addAll({
        {"color": colors[i],"alignment":Alignment(-1.0+stageData.robots[i][1]*2.0/(stageSize-1),-1.0+stageData.robots[i][0]*2.0/(stageSize-1)),"robot": stageData.robots[i]}
      });
    }
  }

  Future<void> dataInstall(id)async{
    stageData = await databaseHelper.getSingleStage(id);
    stageSize = stageData.size;
    robotList = stageData.robots.map((value) => [value[0],value[1]]).toList();
    parameter = parameterList();
    robotsListMap();
    setState(() {});
  }
  Future<void> unlock()async{
    Stage _data;
    _data = await databaseHelper.getSingleStage(stageData.id+1);
    _data.lock = false;
    await databaseHelper.updateStage(_data);
    setState(() {});
  }
}

