import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class AudioRecorderView extends StatefulWidget {

  final Function(String filePath) onSaved;

  const AudioRecorderView({
    Key? key,
    required this.onSaved
  }) : super(key: key);

  @override
  State<AudioRecorderView> createState() => _AudioRecorderViewState();

}

class _AudioRecorderViewState extends State<AudioRecorderView> {

  // 1. Manejo de estado de grabación
  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String? _audioPath;
  bool _isPaused = false;

  Future initRecorder() async{
    final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted){
      throw 'Microphone permissions not granted';
    }

  }

  // 2. Lógica de grabación en método separado
  Future<void> _startRecording() async {

    final dir = await getTemporaryDirectory();
    _audioPath = '${dir.path}/tmp_audio.m4a';

    await _audioRecorder.start(path: _audioPath!,const RecordConfig());

    setState(() {
      _isRecording = true;
      _isPaused = false;

    });

  }

  Future<void> _stopRecording() async {

    await _audioRecorder.stop();

    widget.onSaved(_audioPath!);

    setState(() {
      _isRecording = false;
      _isPaused = false;

    });

  }
  Future<void> _pauseOrResumeRecording() async {
    if (_isPaused) {
      await _audioRecorder.resume();

      setState(() {
        _isPaused = false;
      });
    } else {
      await _audioRecorder.pause();
      setState(() {
        _isPaused = true;
      });

    }

    setState(() {});
  }
  Future<void> _cancelRecording() async {

    await _audioRecorder.stop();

    _audioPath = null;

    setState(() {
      _isRecording = false;
      _isPaused = false;

    });

  }
  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  // 3. UI separada en Stateless Widget
  @override
  Widget build(BuildContext context) {

    return RecordControl(
      isRecording: _isRecording,
      onStart: _startRecording,
      onStop: _stopRecording,
      onPause: _pauseOrResumeRecording,
      onCancel: _cancelRecording, isPause: _isPaused,
    );

  }

}


// Widget reutilizable para controles de grabación  
class RecordControl extends StatefulWidget {

  final bool isRecording;
  final bool isPause;

  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onPause;
  final VoidCallback onCancel;



  const RecordControl({super.key,
    required this.isPause,
    required this.isRecording,
    required this.onStart,
    required this.onStop,
    required this.onPause,
    required this.onCancel,

  });

  @override
  State<RecordControl> createState() => _RecordControlState();
}

class _RecordControlState extends State<RecordControl> {


@override
  void initState() {
    // TODO: implement initState
  super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCancelButton(),

        _buildRecordButton(),

        _buildSendButton(),
      ],
    );

  }

  Widget _buildCancelButton() {
    return IconButton(
        icon: const Icon(Icons.backspace),
        onPressed: widget.onCancel,
    );
  }

  Widget _buildRecordButton() {
    if (widget.isRecording) {
      return IconButton(
        icon: Flash(
          duration: const Duration(seconds: 2),
          infinite: widget.isRecording,
          child: Icon(widget.isPause?Icons.play_arrow:Icons.pause, color: Colors.white),
        ),
        onPressed:  widget.onPause
         // _stopTimer;
        ,
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.mic),
        onPressed: widget.onStart,


      );
    }
  }

  Widget _buildSendButton() {

    return IconButton(
        icon: const Icon(Icons.send),
        onPressed: widget.onStop,
        );
  }
}