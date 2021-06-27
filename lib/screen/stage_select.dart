import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ricochetrobotsapp/models/stage.dart';
import 'package:ricochetrobotsapp/stages/stage_builder.dart';
import 'package:ricochetrobotsapp/utils/admob_service.dart';
import 'package:ricochetrobotsapp/utils/app.dart';
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
      color: Colors.black,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Scaffold(
                appBar: AppBar(
                  title: Text("STAGE SELECT"),
                ),
                body: Container(
                  padding: EdgeInsets.only(top: 50),
                  color: App.background,
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [
                            //     Padding(
                            //       padding: const EdgeInsets.all(10.0),
                            //       child: Container(
                            //         height: 60,
                            //         width: 60,
                            //         color: App.primaryColor,
                            //         child: IconButton(
                            //           onPressed: (){
                            //             soundManager.playLocal('select.mp3');
                            //             Navigator.push(
                            //               context,
                            //               SlidePageRoute(
                            //                 page: TopPage(),
                            //                 settings: RouteSettings(name: '/stage_builder',),
                            //               ),
                            //             );
                            //           },
                            //           //""
                            //           icon: Icon(Icons.chevron_left,size: 45,color: Color(0xFF663300),),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Expanded(
                                child: SingleChildScrollView(
                              child: Container(
                                child:Column(children: stageItems())
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AdMobService().admobBanner(),
          ],
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
                      color: App.primaryColor,
                      height: (MediaQuery.of(context).size.width) / 5,
                      child: InkWell(
                        onTap: () {
                          soundManager.playLocal('start.mp3');
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
                              stageDataList != null ? "${stageDataList[stageNumber].id}" : "",style: TextStyle(fontSize: 20, color: Colors.white),),
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
                    color: Color(0xffDBDADA),
                    height: (MediaQuery.of(context).size.width) / 5,
                    child: Icon(Icons.lock_outline,size: 30,),
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