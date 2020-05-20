import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Stage1 extends StatefulWidget {
  @override
  _Stage1State createState() => _Stage1State();
}

class _Stage1State extends State<Stage1> {
  int stageSize = 5;//5×5
  //2.0/(stageSize-1)
//  Alignment _red = Alignment(-1.0,-1.0);
  var _red = [0,0];
  static var _alignmentRed = Alignment(-1.0,-1.0);
  List<List<int>> parameter;

  Border borderTopRight = Border(top:BorderSide(color: Colors.grey,width: 5.0),right:BorderSide(color: Colors.grey,width: 5.0));
  Border borderTopLeft = Border(top:BorderSide(color: Colors.grey,width: 5.0),left:BorderSide(color: Colors.grey,width: 5.0));
  Border borderBottomRight = Border(bottom:BorderSide(color: Colors.grey,width: 5.0),right:BorderSide(color: Colors.grey,width: 5.0));
  Border borderBottomLeft = Border(bottom:BorderSide(color: Colors.grey,width: 5.0),left:BorderSide(color: Colors.grey,width: 5.0));
  Border borderAll = Border.all(color: Colors.grey,width: 50.0);

  @override
  void initState(){
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
    list[2][2] = 210;
    print(list[0]);
    return  list;
  }

  AlignmentGeometry get _alignment => _alignmentRed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: tiles(),
                  ),
                ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  height: (MediaQuery.of(context).size.width - 20),
                  child: AnimatedAlign(
                    alignment: _alignment,
                    duration: Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        width: (MediaQuery.of(context).size.width - 20-(4*stageSize)) / stageSize,
                        height: (MediaQuery.of(context).size.width - 20-(4*stageSize)) / stageSize,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(100)),
                      ),
                    ),
                    curve: Curves.easeInOut,
                  ),
                ),
              ),
            ],
            ),
          Column(children: moveBottom(),),
          Column(children: autoBottom())
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _alignmentRed = Alignment(-1.0+0.5*2, -1.0+0.5*2);
          setState(() {});
        },
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
              child: Padding(
                padding: EdgeInsets.all(2.0),
                child: Container(
//                  color: Colors.grey[400],
                  height:(MediaQuery.of(context).size.width- 20-(4*stageSize))/stageSize,
                  decoration: BoxDecoration(
                      border:  wallBorder(parameter[i][j])
                  ),
                  child: Text("${(j%stageSize+1)+(i*stageSize)}"),
                ),
              ),
            )
        );
      }
      _list.add(Row(children: _listCache,));
    }
    return _list;
  }

  void rightMove(){
    for(int i=0;i<stageSize;i++){
      if(parameter[_red[0]][_red[1]]==null){

      }else if(parameter[_red[0]][_red[1]]%5 == 0){

      }else if(parameter[_red[0]][_red[1]]%7 == 0){
        print("stop");
        break;
      }
      if(_red[1] == stageSize-1){
        break;
      }
        _red[1]+= 1;
      print(_red[1]);
    }
  }
  BoxBorder wallBorder(number){
    if(number== null ){
      return Border();
    }else{
      if(number == 14 ){
        return borderTopRight;
      }else if(number == 10){
        return borderTopLeft;
      }else if(number == 21){
        return borderBottomRight;
      }else if(number == 15){
        return borderBottomLeft;
      }else if(number == 210){
        return borderAll;
      }
    }
  }
  List<Widget> moveBottom(){
    List<String> _text = ["上","下","左","右"];
    List<dynamic> alignment =[0.0,-0.5,0.0,0.5,-0.5,0.0,0.5,0.0];

    List<Widget> _list = [];
    for(int i=0;i<4;i++){
      _list.add(
          InkWell(
            child: Container(
              color: Colors.yellow,
              child: Text(_text[i]),
            ),
            onTap: (){
              _alignmentRed += Alignment(alignment[2*i],alignment[2*i+1]);
              setState(() {
              });
            },
          )
      );
    }
    return _list;
  }

  List<Widget> autoBottom(){
    List<String> _text = ["上","下","左","右"];
    List<dynamic> alignment =[0.0,-0.5,0.0,0.5,-0.5,0.0,0.5,0.0];

    List<Widget> _list = [];
    for(int i=0;i<4;i++){
      _list.add(
          InkWell(
            child: Container(
              child: Text(_text[i]),
            ),
            onTap: (){
              rightMove();
              setState(() {
              });
            },
          )
      );
    }
    return _list;
  }
}
