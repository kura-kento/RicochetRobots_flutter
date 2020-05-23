import 'package:flutter/material.dart';
import 'package:ricochetrobotsapp/stages/stage_1.dart';

class TopPage extends StatefulWidget {
  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(height: 400,),
            FlatButton(
              child: Text("スタート"),
              onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return Stage1();
//                      return StageSelect();
                    },
                  )
                );
              },
            )
          ],
        ),
      )
    );
  }
}
