import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ricochetrobotsapp/models/stage.dart';
import 'package:ricochetrobotsapp/screen/stage_select.dart';
import 'package:ricochetrobotsapp/screen/top_page.dart';
import 'package:ricochetrobotsapp/utils/database_help.dart';
import 'package:ricochetrobotsapp/utils/page_animation.dart';
import 'package:ricochetrobotsapp/utils/sounds.dart';



class StageBuilder extends StatefulWidget {
  StageBuilder({Key key,this.id,this.stageSize ,this.wall, this.robotList}) : super(key: key);
  final int id;
  final int stageSize;
  final List<List<int>> wall;
  final List<List<int>> robotList;
  @override
  _StageBuilderState createState() => _StageBuilderState();
}

class _StageBuilderState extends State<StageBuilder> {

  final SoundManager soundManager = SoundManager();

  // int stageSize = 5;//5×5
  //2.0/(stageSize-1)
  List<int>  after = [0,0];
  List<List<int>> parameter;
  List<List<int>> initRobotList;
  Stopwatch s = Stopwatch();
  List<Map<String,dynamic>> robotsMap = List<Map<String,dynamic>>();

  DatabaseHelper databaseHelper = DatabaseHelper();
  Stage nextStageData;

  @override
  void initState(){
    initRobotList= widget.robotList.map((value) => [value[0],value[1]]).toList();
    s.start();
    parameter = parameterList();
    robotsListMap();
    nextDBinstall(widget.id);
    super.initState();
  }

  List parameterList(){
    List<List<int>> list =[];
    for(int i=0;i < widget.stageSize;i++){
      List<int> listCache = [];
      for(int j=0;j < widget.stageSize;j++){
        listCache.add(null);
      }
      list.add(listCache);
    }
    widget.wall.forEach((value) => list[value[0]][value[1]] = value[2]);
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
                child: Center(child: Text("ステージ${widget.id}")),
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
                  Stack(children: robot())
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
    for(int i=0; i<widget.stageSize; i++){
      List<Widget> _listCache = [];
      for(int j=0; j<widget.stageSize;j++){
        _listCache.add(
            Expanded(
              flex: 1,
              child: Container(
                margin:EdgeInsets.all(2.0),
                height:(MediaQuery.of(context).size.width- 20-(4*widget.stageSize))/widget.stageSize,
                decoration: BoxDecoration(
                    color: parameter[i][j] != null && parameter[i][j]%11 == 0 ? Colors.red : Colors.transparent,
                    border:  wallBorder(parameter[i][j])
                ),
                  child: Text("[${i},${j}]"),
              ),

            )
        );
      }
      _list.add(Row(children: _listCache,));
    }
    return _list;
  }
  List<Widget>iconButtons(){
    List _icons = [Icons.refresh,Icons.apps,Icons.home];
    List _route = [StageBuilder(stageSize: widget.stageSize,wall: widget.wall,robotList: initRobotList,id: widget.id),StageSelect(),TopPage()];
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
      );
    }
    return _cache;
  }
  List<Widget> robot(){
    List<Widget> _list = [];
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
                    width: (MediaQuery.of(context).size.width-50-20-(4*widget.stageSize)) / widget.stageSize,
                    height: (MediaQuery.of(context).size.width-50-20-(4*widget.stageSize)) / widget.stageSize,
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
    outside: for(int i = 0;i < widget.stageSize ; i++){
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
    outside: for(int i = 0;i < widget.stageSize ; i++){
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
      if(after[0] == widget.stageSize-1)break;
      after[0]+= 1;
    }
  }
  void rightMove(mapIndex){
    after = robotsMap[mapIndex]["robot"];
    outside: for(int i = 0;i < widget.stageSize ; i++){
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
      if(after[1] == widget.stageSize-1)break;
      after[1]+= 1;
    }
  }
  void leftMove(mapIndex){
    after = robotsMap[mapIndex]["robot"];
    outside: for(int i = 0;i < widget.stageSize ; i++){
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
    robotsMap[mapIndex]["alignment"] = Alignment(-1.0 + after[1] * (2.0/(widget.stageSize-1)),-1.0+ after[0] * (2.0/(widget.stageSize-1)));
    setState(() {});
    if(parameter[after[0]][after[1]] == null){

    }else if(parameter[after[0]][after[1]]% 11 == 0 && mapIndex == 0){
      soundManager.playLocal('goal.mp3');
      s.stop();
      unlock();
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("タイトル"),
            content: Text("TIME ${s.elapsed.toString().substring(2, 11)}"),
            actions: <Widget>[
              // ボタン領域
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text("OK"),
                onPressed: (){
                  Navigator.push(
                    context,
                    SlidePageRoute(
                      page: StageBuilder(id: nextStageData.id,stageSize: nextStageData.size,wall: nextStageData.parameter,robotList: nextStageData.robots,),
                      settings: RouteSettings(name: '/stage_builder',),
                    ),
                  );
                },
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
    for(int i=0;i<widget.robotList.length;i++){
      robotsMap.addAll({
        {"color": colors[i],"alignment":Alignment(-1.0+widget.robotList[i][1]*2.0/(widget.stageSize-1),-1.0+widget.robotList[i][0]*2.0/(widget.stageSize-1)),"robot": widget.robotList[i]}
      });
    }
  }

  Future<void> nextDBinstall(id)async{
    nextStageData = await databaseHelper.getNextStage(id);
    print(nextStageData.id);
    setState(() {});
  }
  Future<void> unlock()async{
    nextStageData.lock = false;
    await databaseHelper.updateStage(nextStageData);
    setState(() {});
  }
}

