import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ricochetrobotsapp/models/stage.dart';
import 'package:ricochetrobotsapp/screen/top_page.dart';
import 'package:ricochetrobotsapp/utils/database_help.dart';
import 'package:ricochetrobotsapp/utils/page_animation.dart';
import 'package:ricochetrobotsapp/utils/sounds.dart';
import 'package:trotter/trotter.dart';



class RandomStage extends StatefulWidget {
  RandomStage({Key key,this.id}) : super(key: key);
  final int id;
  @override
  _RandomStageState createState() => _RandomStageState();
}

class _RandomStageState extends State<RandomStage> {

  final SoundManager soundManager = SoundManager();
  Stopwatch s = Stopwatch();
  // int stageSize = 5;//5×5
  //2.0/(stageSize-1)
  int stageSize = 10;
  List<int>  after = [0,0];
  List<List<int>> parameter;
  List<List<int>> robotList;
  List<Map<String,dynamic>> robotsMap = List<Map<String,dynamic>>();

  DatabaseHelper databaseHelper = DatabaseHelper();
  Stage stageData;

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

//  AlignmentGeometry get _alignment => robotsMap[0]["alignment"];


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[400],
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                height: 50,
                child: Center(child: Text("STAGE${widget.id}")),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: iconButtons()
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: tiles(),),
                  ),
                  Stack(children: robot()),
                  Text('')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  List<Widget> tiles(){
    List<Widget> _list = [];
    if(parameter!=null) {
      for (int i = 0; i < stageSize; i++) {
        List<Widget> _listCache = [];
        for (int j = 0; j < stageSize; j++) {
          _listCache.add(
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(2.0),
                  height: (MediaQuery.of(context).size.width - 20 - (4 * stageSize)) / stageSize,
                  decoration: BoxDecoration(
                      color: parameter[i][j] != null && parameter[i][j] % 11 == 0 ? Colors.red : Colors.transparent,
                      border: wallBorder(parameter[i][j])
                  ),
                  child: Text(""),
                ),
              )
          );
        }
        _list.add(Row(children: _listCache,));
      }
    }
    return _list;

  }
  List<Widget>iconButtons(){
    List _icons = [Icons.refresh,Icons.cached,Icons.home];
    List _route = ["","",TopPage()];
    List<Widget> _cache=[];
    for(int i = 0;i < _icons.length; i++){
      _cache.add(
        FlatButton.icon(
          icon:Icon(
              _icons[i],
              color: Colors.black
          ),
          label: Text(""),
          onPressed: (){
            if(i==1){
              shuffle();
            }else if(i==0){
              initRobots();
            }else{
              soundManager.playLocal('select.mp3');
              Navigator.push(
                context,
                SlidePageRoute(
                  page: _route[i],
                  settings: RouteSettings(name: '/stage_builder',),
                ),
              );
            }

          },
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
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              height: (MediaQuery.of(context).size.width - 20),
              child: AnimatedAlign(
                alignment: robotsMap[mapIndex]["alignment"],
                duration: Duration(milliseconds: 500),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    width: (MediaQuery.of(context).size.width-50-20-(4*stageSize)) / stageSize,
                    height: (MediaQuery.of(context).size.width-50-20-(4*stageSize)) / stageSize,
                    decoration: BoxDecoration(
                        color: robotsMap[mapIndex]["color"],
                        borderRadius: BorderRadius.circular(100)),
                  ),
                ),
                curve: Curves.easeInOut,
              ),
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
      print(after);
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

  moveProcess(mapIndex){
    soundManager.playLocal('move.mp3');
    robotsMap[mapIndex]["alignment"] = Alignment(-1.0 + after[1] * (2.0/(stageSize-1)),-1.0+ after[0] * (2.0/(stageSize-1)));
    setState(() {});
    if(parameter[after[0]][after[1]] == null){

    }else if(parameter[after[0]][after[1]]% 11 == 0 && mapIndex == 0){
      soundManager.playLocal('goal.mp3');
      s.stop();
      //変更予定
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            // contentPadding: EdgeInsets.only(bottom: 30.0),
            title: Text("STAGE"+widget.id.toString()),
            content: Text("TIME ${s.elapsed.toString().substring(2, 11)}"),
            actions: <Widget>[
              // ボタン領域
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey,width:1.0)
                ),
                child: IconButton(
                  icon: Icon(Icons.reply),
                  iconSize: 25,
                  color: Colors.lightBlueAccent,
                  onPressed: (){
                    soundManager.playLocal('select.mp3');
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey,width:1.0)
                ),
                child: IconButton(
                  icon: Icon(Icons.play_arrow),
                  iconSize: 25,
                  color: Colors.lightBlueAccent,
                  onPressed: (){
                    soundManager.playLocal('select.mp3');
                    Navigator.push(
                      context,
                      SlidePageRoute(
                        page: RandomStage(id: widget.id+1),
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

  BoxBorder wallBorder(number){
    double _top = 1.0;
    double _bottom = 1.0;
    double _left = 1.0;
    double _right = 1.0;
    if(number == null){
    }else{
      if(number%2 == 0){_top = 5.0;}
      if(number%3 == 0){_bottom = 5.0;}
      if(number%5 == 0){_left = 5.0;}
      if(number%7 == 0){_right = 5.0;}
      if(number%210 == 0){
        _top = 40.0;
        _bottom = 40.0;
        _left = 40.0;
        _right = 40.0;
      }
    }
    return Border(top:BorderSide(color: Colors.grey,width: _top),bottom:BorderSide(color: Colors.grey,width: _bottom),left:BorderSide(color: Colors.grey,width: _left),right:BorderSide(color: Colors.grey,width: _right));
  }
  void robotsListMap(){
    List<Color> colors = [Colors.red,Colors.blue,Colors.green,Colors.yellow];
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
    robotsListMap();
    shuffle();
    setState(() {});
  }
  shuffle(){
    parameter = parameterList();
    List<String> a=[];
    final bagOfItems = [1,2,3,4,5,6],
        combos = Amalgams(2, bagOfItems);
    for (final combo in combos()) {
      a.add("${combo[0]}-${combo[1]}");
    }
    a.remove("2-1");
    a.remove("3-1");
    a.remove("6-1");
    a.remove("6-2");
    a.remove("6-4");
    a.remove("6-5");
    a.remove("4-6");
    a.remove("5-6");
    a.remove("1-6");
    a.remove("2-6");
    a.remove("1-3");
    a.remove("1-4");
    //をparameterにいれる。
    List<int> wallInt = [10,14,15,21];
    var b;
    for(int i=0;i < 8;i++){
      a.shuffle();
      wallInt.shuffle();
      b = a[0].split("-");
      if(i==0){
        parameter[int.parse(b[0])][int.parse(b[1])] = wallInt[0]*11;
      }else{
        parameter[int.parse(b[0])][int.parse(b[1])] = wallInt[0];
      }
      for(int first=0;first < 3;first++){
        for(int last=0;last < 3;last++){
          a.remove("${int.parse(b[0])+first-1}"+"-"+"${int.parse(b[1])+last-1}");
        }
      }
      if(a.length == 0){break;}
    }
    print(a.length);
    setState(() {});
  }
  Future<void> initRobots()async{
    stageData = await databaseHelper.getSingleStage(24);
    robotsMap = List<Map<String,dynamic>>();
    robotList = stageData.robots.map((value) => [value[0],value[1]]).toList();
    robotsListMap();
    setState(() {});
  }
}

