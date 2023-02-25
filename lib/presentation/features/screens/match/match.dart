import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:math' as math show sin, pi, sqrt;
import 'package:flutter/animation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:music_app/core/api/matchsong_service.dart';

class MatchScreen extends StatefulWidget {
  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  // FlutterSoundPlayer _myPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;
  FlutterSoundRecorder? _myRecorder = FlutterSoundRecorder();
  bool _isRecording = false;

  String songName = "";

  @override
  void initState() {
    super.initState();

    _myRecorder!.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
  }

  @override
  void dispose() {
    _myRecorder!.closeAudioSession();
    _myRecorder = null;
    super.dispose();
  }

  Future<void> record() async {
    await _myRecorder!.startRecorder(
      toFile: 'hello.aac',
      codec: Codec.aacADTS,
    );
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> stopRecorder() async {
    var path = await _myRecorder!.stopRecorder();
    print('Recorded audio: $path');
    setState(() {
      _isRecording = false;
    });
    String result = await recognizeSong(File(path!));
    if (result != "")
      setState(() {
        songName = "Music Recognized!\nSong name: " + result;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(songName),
            SizedBox(
              height: 20.h,
            ),
            Text('Recording: $_isRecording'),
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await record();
                  },
                  child: Text('Record'),
                ),
                SizedBox(
                  width: 10.w,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await stopRecorder();
                  },
                  child: Text('Stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
