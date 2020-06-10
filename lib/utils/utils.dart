import 'package:flutter/material.dart';

class Utils{
//ランキングの秒数が９９９秒を超えたらエラーになるのでDBにいれる際に細工する。
  static Widget intWidget(String value,int number){
    List<Widget> _cacheList = List<Widget>();
    var _valueList = value.split("");
    for(int i = 0;i < number ;i++){
      if(i < _valueList.length){
        _cacheList.add(
            Expanded(
              flex: 1,
              child: Align(
                  alignment: Alignment.center,
                  child: Text(_valueList[i])
              ),
            )
        );
      }else{
        _cacheList.insert(
            0,
            Expanded(
              flex: 1,
              child: Text(""),
            )
        );
      }
    }
    return Row(children: _cacheList);
  }

}
