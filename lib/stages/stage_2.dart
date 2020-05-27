import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ricochetrobotsapp/models/stage.dart';
import 'package:ricochetrobotsapp/screen/top_page.dart';
import 'package:ricochetrobotsapp/utils/database_help.dart';


class Stage2 extends StatefulWidget {
  @override
  _Stage2State createState() => _Stage2State();
}

class _Stage2State extends State<Stage2> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  Stage stageData;

  int stageSize = 5;//5×5
  //2.0/(stageSize-1)
  List<int>  after = [0,0];
  List<List<int>> parameter;
  List<List<int>> wallList =[[3,3,231],[2,2,210]];
  Stopwatch s = Stopwatch();
  List<Map<String,dynamic>> robotsMap = [{"color": Colors.red,"alignment":Alignment(-1.0,1.0),"robot":[4,0]},
                                         {"color": Colors.blue,"alignment":Alignment(-0.5,1.0),"robot":[4,1]}
                                        ];
  Border borderTopRight = Border(top:BorderSide(color: Colors.grey,width: 5.0),bottom:BorderSide(color: Colors.grey,width: 1.0),left:BorderSide(color: Colors.grey,width: 1.0),right:BorderSide(color: Colors.grey,width: 5.0));
  Border borderTopLeft = Border(top:BorderSide(color: Colors.grey,width: 5.0),left:BorderSide(color: Colors.grey,width: 5.0),right:BorderSide(color: Colors.grey,width: 1.0));
  Border borderBottomRight = Border(top:BorderSide(color: Colors.grey,width: 1.0),bottom:BorderSide(color: Colors.grey,width: 5.0),right:BorderSide(color: Colors.grey,width: 5.0),left:BorderSide(color: Colors.grey,width: 1.0));
  Border borderBottomLeft = Border(top:BorderSide(color: Colors.grey,width: 1.0),bottom:BorderSide(color: Colors.grey,width: 5.0),left:BorderSide(color: Colors.grey,width: 5.0),right:BorderSide(color: Colors.grey,width: 1.0));
  Border borderAll = Border.all(color: Colors.grey,width: 50.0);

  @override
  void initState(){
    s.start();
    parameter = parameterList();
    dbInstall(0);
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
    list[3][3] = 231;
    list[2][2] = 210;
    return  list;
  }

//  AlignmentGeometry get _alignment => robotsMap[0]["alignment"];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
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
    );
  }
  List<Widget> tiles(){
    List<Widget> _list = [];
    for(int i=0; i<stageSize; i++){
      List<Widget> _listCache = [];
      for(int j=0; j<stageSize;j++){
        _listCache.add(
            Expanded(
              flex: 1,
              child: Container(
                margin:EdgeInsets.all(2.0),
                height:(MediaQuery.of(context).size.width- 20-(4*stageSize))/stageSize,
                decoration: BoxDecoration(
                    color: parameter[i][j] != null && parameter[i][j]%11 == 0 ? Colors.red : Colors.transparent,
                    border:  wallBorder(parameter[i][j])
                ),
//                  child: Text("${(j%stageSize+1)+(i*stageSize)}"),
              ),

            )
        );
      }
      _list.add(Row(children: _listCache,));
    }
    return _list;
  }
  List<Widget>iconButtons(){
    List _icons=[Icons.refresh,Icons.home,Icons.lightbulb_outline];
    List _route=[Stage2(),TopPage(),TopPage()];
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
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return _route[i];
                  },
                )
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

      }else if(parameter[after[0]][after[1]] % 2 == 0 ){
        break;
      }else if(parameter[after[0]][after[1]] % 3 == 0 ){
        if(i != 0) { after[0] += 1; break; }
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

      }else if(parameter[after[0]][after[1]] % 5 == 0){
        break;
      }else if(parameter[after[0]][after[1]] % 7 == 0){
        if(i != 0) { after[1] += 1; break; }
      }
      if(after[1] == 0)break;
      after[1]+= -1;
    }
  }

  moveProcess(mapIndex){
    robotsMap[mapIndex]["alignment"] = Alignment(-1.0 + after[1] * 0.5,-1.0+ after[0] * 0.5);
    setState(() {});
    if(parameter[after[0]][after[1]] == null){

    }else if(parameter[after[0]][after[1]]% 11 == 0){
      s.stop();
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
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return Stage2();
                        },
                      )
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
    if(number == null){
      return Border.all(color: Colors.grey,width: 1.0);
    }else{
      if(number%210 == 0) {
        return borderAll;
      }else if(number%14 ==0){
        return borderTopRight;
      }else if(number%10 == 0){
        return borderTopLeft;
      }else if(number%21 == 0){
        return borderBottomRight;
      }else if(number%15 == 0){
        return borderBottomLeft;
      }else{
        return Border();
      }
    }
  }

  Future<void> dbInstall(index)async{
    List<Stage> stageList = await databaseHelper.getStageList();
    stageData = stageList[index];
    setState(() {});
  }
}
