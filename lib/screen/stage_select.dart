import 'package:flutter/material.dart';

class StageSelect extends StatefulWidget {
  @override
  _StageSelectState createState() => _StageSelectState();
}

class _StageSelectState extends State<StageSelect> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child:Column(children: stageItems())
        ),
      ),
    );
  }
  List<Widget> stageItems(){
    List<Widget> _list = [];
    for(int i=0; i<5; i++){
      List<Widget> _listCache = [];
        for(int j=0; j<2;j++){
          _listCache.add(
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.grey[400],
                  height:(MediaQuery.of(context).size.width)/2,
                  child: Text("${(j%2+1)+(i*2)}"),
                ),
              ),
            )
          );
        }
      _list.add(Row(children: _listCache,));
    }
    return _list;
  }
}
