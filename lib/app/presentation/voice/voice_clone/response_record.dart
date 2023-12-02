import 'dart:io';

import 'package:ariapp/app/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class ResponseRecord extends StatefulWidget {
  const ResponseRecord({super.key, required this.onStop, required this.namePath});
  final void Function(String path) onStop;
  final String namePath;
  @override
  State<ResponseRecord> createState() => _ResponseRecordState();
}

class _ResponseRecordState extends State<ResponseRecord> {

  Codec _codec = Codec.aacMP4;
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  bool isRecording = false;

  Future record()async{
    if(!isRecorderReady) return;

    await recorder.startRecorder(toFile:'${widget.namePath}.mp4',codec: _codec );
  }
  Future stop() async{
    if(!isRecorderReady) return;

    final path  = await recorder.stopRecorder();
    final audioFile = File(path!);
    widget.onStop(path);
    print(audioFile);

  }
  Future initRecorder() async{
    final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted){
      throw 'Microphone permissions not granted';
    }
    isRecorderReady = true;
    await recorder.openRecorder();

  }

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),

      decoration:const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            blurRadius: 20,
          ),
        ],
      ),
      child: InkWell(

        onTap: () async {
          if(recorder.isRecording){
            await stop();
            setState(() {
              isRecording = false;
            });
          }else {
            await record();
            setState(() {
              isRecording = true;
            });
          }
        },
        child: Icon(
          isRecording ? Icons.stop : Icons.mic,
          size: 30,
          color: Styles.primaryColor,
        ),
      ),
    );
  }
}
