import 'package:flutter/material.dart';
import 'package:ricochetrobotsapp/models/stage.dart';
import 'package:ricochetrobotsapp/stages/stage_builder.dart';
import 'package:ricochetrobotsapp/stages/stage_1.dart';
import 'package:ricochetrobotsapp/stages/stage_2.dart';
import 'package:ricochetrobotsapp/utils/database_help.dart';

class StageSelect extends StatefulWidget {
  @override
  _StageSelectState createState() => _StageSelectState();
}

class _StageSelectState extends State<StageSelect> {
var stageName = Stage2();

DatabaseHelper databaseHelper = DatabaseHelper();
List<Stage> stageData;

 List<List<int>> wall = [[3,3,231],[2,2,210]];

@override
void initState(){
  dbInstall(0);
  super.initState();
}

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.grey,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              child:Column(children: stageItems())
            ),
          ),
        ),
      ),
    );
  }
  List<Widget> stageItems(){
    List<Widget> _list = [];
    for(int i=0; i<1; i++){
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
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return StageBuilder(stageSize: stageData[j].size,wall: stageData[j].parameter,robotList: stageData[j].robots);
                              },
                            )
                        );
                      },
                    )
                  ),
              ),
            ),
          );
        }
      _list.add(Row(children: _listCache,));
    }
    return _list;
  }
  Future<void> dbInstall(index)async{
    stageData = await databaseHelper.getStageList();
    setState(() {});
  }
}
