import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class SoundManager {
  AudioPlayer audioPlayer = AudioPlayer();
  Future playLocal(String localFileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$localFileName');
    if (!file.existsSync()) {
      final soundData = await rootBundle.load('assets/sounds/$localFileName');
      final bytes = soundData.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
    }
    await audioPlayer.play(file.path, isLocal: true);
    if(localFileName=='Blue_Moon_2.mp3') {
      await audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    }
  }
}