
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ricochetrobotsapp/screen/top_page.dart';
import 'package:ricochetrobotsapp/stages/stage_2.dart';


class Stage1 extends StatefulWidget {
  @override
  _Stage1State createState() => _Stage1State();
}

class _Stage1State extends State<Stage1> {
  int stageSize = 5;//5×5
  //2.0/(stageSize-1)
  Alignment _alignmentRed;
  List<int> _red = [1,0];
  List<int> beforeRed = [0,0];
  List<List<int>> parameter;
  Stopwatch s = Stopwatch();


  Border borderTopRight = Border(top:BorderSide(color: Colors.grey,width: 5.0),bottom:BorderSide(color: Colors.grey,width: 1.0),left:BorderSide(color: Colors.grey,width: 1.0),right:BorderSide(color: Colors.grey,width: 5.0));
  Border borderTopLeft = Border(top:BorderSide(color: Colors.grey,width: 5.0),left:BorderSide(color: Colors.grey,width: 5.0),right:BorderSide(color: Colors.grey,width: 1.0));
  Border borderBottomRight = Border(top:BorderSide(color: Colors.grey,width: 1.0),bottom:BorderSide(color: Colors.grey,width: 5.0),right:BorderSide(color: Colors.grey,width: 5.0),left:BorderSide(color: Colors.grey,width: 1.0));
  Border borderBottomLeft = Border(top:BorderSide(color: Colors.grey,width: 1.0),bottom:BorderSide(color: Colors.grey,width: 5.0),left:BorderSide(color: Colors.grey,width: 5.0),right:BorderSide(color: Colors.grey,width: 1.0));
  Border borderAll = Border.all(color: Colors.grey,width: 50.0);

  @override
  void initState(){
    s.start();
    _alignmentRed = Alignment(-1.0+2.0/(stageSize-1)*_red[1],-1.0+2.0/(stageSize-1)*_red[0]);
    parameter = parameterList();
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
    list[1][3] = 14;
    list[3][3] = 231;
    list[2][2] = 210;
    print(list[1]);
    return  list;
  }

  AlignmentGeometry get _alignment => _alignmentRed;
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
                GestureDetector(
                  onVerticalDragUpdate: (detail) {
                    if (detail.primaryDelta > 5 || detail.primaryDelta < -5){
                      detail.primaryDelta > 5 ? bottomMove() : topMove();
                      //ここに１秒くらい停止させる。
                      moveProcess();
                    }
                  },
                  onHorizontalDragUpdate: (detail) {
                    if (detail.primaryDelta > 5 || detail.primaryDelta < -5) {
                      detail.primaryDelta > 5 ? rightMove() : leftMove();
                      //ここに１秒くらい停止させる。
                      moveProcess();
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      height: (MediaQuery.of(context).size.width - 20),
                      child: AnimatedAlign(
                        alignment: _alignment,
                        duration: Duration(milliseconds: 500),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            margin: EdgeInsets.all(5.0),
                            width: (MediaQuery.of(context).size.width-50-20-(4*stageSize)) / stageSize,
                            height: (MediaQuery.of(context).size.width-50-20-(4*stageSize)) / stageSize,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(100)),
                          ),
                        ),
                        curve: Curves.easeInOut,
                      ),
                    ),
                  ),
                ),
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
                      color: parameter[i][j] != null && parameter[i][j]%11 ==0 ? Colors.red : Colors.transparent,
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
  void topMove(){
    beforeRed = [_red[0],_red[1]];
    for(int i = 0;i < stageSize ; i++){
      if(parameter[_red[0]][_red[1]] == null){

      }else if(parameter[_red[0]][_red[1]] % 2 == 0){
        break;
      }else if(parameter[_red[0]][_red[1]] % 3 == 0){
        if(i != 0) { _red[0] += 1; break; }
      }
      if(_red[0] == 0)break;
      _red[0]+= -1;
    }
  }
  void bottomMove(){
    beforeRed = [_red[0],_red[1]];
    for(int i = 0;i < stageSize ; i++){
      if(parameter[_red[0]][_red[1]] == null){

      }else if(parameter[_red[0]][_red[1]] % 2 == 0){
        if(i != 0) { _red[0] += -1; break; }
      }else if(parameter[_red[0]][_red[1]] % 3 == 0){
        break;
      }
      if(_red[0] == stageSize-1)break;
      _red[0]+= 1;
    }
  }
  void rightMove(){
    beforeRed = [_red[0],_red[1]];
    for(int i = 0;i < stageSize ; i++){
      if(parameter[_red[0]][_red[1]] == null){

      }else if(parameter[_red[0]][_red[1]] % 5 == 0){
        if(i != 0) { _red[1] += -1; break; }
      }else if(parameter[_red[0]][_red[1]] % 7 == 0){
        break;
      }
      if(_red[1] == stageSize-1)break;
      _red[1]+= 1;
    }
  }
  void leftMove(){
    print(_red);
    beforeRed = [_red[0],_red[1]];
    for(int i = 0;i < stageSize ; i++){
      if(parameter[_red[0]][_red[1]] == null){

      }else if(parameter[_red[0]][_red[1]] % 5 == 0){
        break;
      }else if(parameter[_red[0]][_red[1]] % 7 == 0){
        if(i != 0) { _red[1] += 1; break; }
      }
      if(_red[1] == 0)break;
      _red[1]+= -1;
    }
  }

  BoxBorder wallBorder(number){
    if(number == null ){
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
  moveProcess(){
    _alignmentRed += Alignment((_red[1] - beforeRed[1]) * 0.5, (_red[0] - beforeRed[0]) * 0.5);
    setState(() {});
    if(parameter[_red[0]][_red[1]] == null){

    }else if(parameter[_red[0]][_red[1]]% 11 == 0){
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
  List<Widget>iconButtons(){
    List _icons=[Icons.refresh,Icons.home,Icons.lightbulb_outline];
    List _route=[Stage1(),TopPage(),TopPage()];
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
}
