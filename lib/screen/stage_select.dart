import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ricochetrobotsapp/models/stage.dart';
import 'package:ricochetrobotsapp/screen/top_page.dart';
import 'package:ricochetrobotsapp/stages/stage_builder.dart';
import 'package:ricochetrobotsapp/utils/database_help.dart';
import 'package:ricochetrobotsapp/utils/page_animation.dart';
import 'package:ricochetrobotsapp/utils/sounds.dart';

class StageSelect extends StatefulWidget {
  @override
  _StageSelectState createState() => _StageSelectState();
}

class _StageSelectState extends State<StageSelect> {

final SoundManager soundManager = SoundManager();
DatabaseHelper databaseHelper = DatabaseHelper();
List<Stage> stageDataList;
int dataLength = 0;

@override
void initState(){
  dbInstall();
  super.initState();
}

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.grey,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    width: 70,
                    child: IconButton(
                      onPressed: (){
                        soundManager.playLocal('select.mp3');
                        Navigator.push(
                          context,
                          SlidePageRoute(
                            page: TopPage(),
                            settings: RouteSettings(name: '/stage_builder',),
                          ),
                        );
                      },
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Container(
                  child:Column(children: stageItems())
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
  List<Widget> stageItems(){
    List<Widget> _list = [];
    for(int i=0; i<dataLength/5; i++){
      List<Widget> _listCache = [];
        for(int j=0; j< ((dataLength -5*i >= 5 )? 5 : dataLength%5 );j++){
          int stageNumber = j + 5 * i;
          if(stageDataList[stageNumber].lock == false) {
            _listCache.add(
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0,color:Colors.black)
                      ),
                    //  color: Colors.grey[400],
                      height: (MediaQuery.of(context).size.width) / 5,
                      child: InkWell(
                        onTap: () {
                          soundManager.playLocal('select.mp3');
                          Navigator.push(
                            context,
                            SlidePageRoute(
                              page: StageBuilder(id: stageDataList[stageNumber].id),
                              settings: RouteSettings(name: '/stage_builder',),
                             ),
                          );
                        },
                        child: Center(
                          child: Text(
                              stageDataList != null ? "${stageDataList[stageNumber].id}" : ""),
                        ),
                      )
                  ),
                ),
              ),
            );
          }else{
            _listCache.add(
              Expanded(
                flex: 1,
                child:  Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0,color:Colors.black)
                    ),
                    height: (MediaQuery.of(context).size.width) / 5,
                    child: Icon(Icons.lock_outline,size: 30),
                  ),
                ) ,
              )

            );
          }
        }
      _list.add(Row(children: _listCache,));
    }
    return _list;
  }
  Future<void> dbInstall()async{
    stageDataList = await databaseHelper.getStageList();
    dataLength = stageDataList.length;
    setState(() {});
  }
}