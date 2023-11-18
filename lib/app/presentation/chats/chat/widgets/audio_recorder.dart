import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';

import '../../../../config/styles.dart';
import '../bloc/chat_bloc.dart';

class AudioRecorder extends StatefulWidget {
  final void Function(String path) onStop;
  final double iconSize;
  const AudioRecorder({Key? key, required this.onStop, required this.iconSize,}) : super(key: key);

  @override
  State<AudioRecorder> createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  int _recordDuration = 0;
  Timer? _timer;
  final _audioRecorder = Record();
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Amplitude? _amplitude;
  bool isRecording = false;

  @override
  void initState() {
    _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
      setState(() => _recordState = recordState);
    });

    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) => setState(() => _amplitude = amp));

    super.initState();
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // We don't do anything with this but printing
        final isSupported = await _audioRecorder.isEncoderSupported(
          AudioEncoder.aacLc,
        );
        if (kDebugMode) {
          print('${AudioEncoder.aacLc.name} supported: $isSupported');
        }

        // final devs = await _audioRecorder.listInputDevices();
        // final isRecording = await _audioRecorder.isRecording();

        await _audioRecorder.start();
        _recordDuration = 0;

        _startTimer();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stop() async {

    _timer?.cancel();
    _recordDuration = 0;

    final path = await _audioRecorder.stop();

    if (path != null) {
      widget.onStop(path);
    }
  }
  Future<void> _stopTest() async {

    _timer?.cancel();
    _recordDuration = 0;

    final path = await _audioRecorder.stop();
    await _audioRecorder.start();


    if (path != null) {
      widget.onStop(path);
    }
  }
  Future<void> _stopAndDelete() async {
    _timer?.cancel();
    _recordDuration = 0;

    await _audioRecorder.stop();

    await _audioRecorder.dispose();
  }

  Future<void> _pause() async {
    _timer?.cancel();
    await _audioRecorder.pause();
  }

  Future<void> _resume() async {
    _startTimer();
    await _audioRecorder.resume();
  }

  Future<void> _sendAudio() async {
    if (_recordState == RecordState.pause) {
      await _stopAndDelete();
    }
    final path = await _audioRecorder.stop();
    isRecording = false;
    if (path != null) {
      widget.onStop(path);
    }
  }


  Widget _buildSendButton() {
    return IconButton(
      onPressed:isRecording ? () {
        _sendAudio();
      }: null,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue),
      ),
      icon: const Icon(
        Icons.send,
        color: Color(0xFF354271),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      height:  isRecording ?MediaQuery.of(context).size.height*0.15:MediaQuery.of(context).size.height*0.1,
      decoration: isRecording ? const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only( topLeft : Radius.circular(20), topRight : Radius.circular(20),)
      ): const BoxDecoration(),
      child: Column(
        children: [
          isRecording ?const SizedBox():
          const Divider(
              color: Color(0xFF354271),
              thickness: 2
          ),          isRecording ? const Text('Grabando audio') : const SizedBox(),
          isRecording ? _buildText() : const SizedBox(),
    
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              _buildDeleteButton(),
              //_buildPauseResumeControl(),
              _buildRecordPauseResumeControl(),
              //_buildRecordStopControl(),
              _buildSendButton(),

            ],
          ),
         // if (_amplitude != null) ...[
          //  const SizedBox(height: 40),
          //  Text('Current: ${_amplitude?.current ?? 0.0}'),
          //  Text('Max: ${_amplitude?.max ?? 0.0}'),
          //],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recordSub?.cancel();
    _amplitudeSub?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }


  Widget _buildRecordPauseResumeControl() {
    late Icon icon;
    late Color color;
    bool showPauseResume = false;

    if (_recordState == RecordState.stop) {
      icon = Icon(Icons.mic, color: Styles.primaryColor, size: widget.iconSize);
      color = Colors.white;
      showPauseResume = false;
    } else if (_recordState == RecordState.record) {
      icon = Icon(Icons.pause, color: Colors.white, size: widget.iconSize);
      color = Styles.primaryColor;
      showPauseResume = true;
    } else {
      //resume
      icon = Icon(Icons.mic, color: Colors.white, size: widget.iconSize);
      color = Styles.primaryColor;
      showPauseResume = true;
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.42),
            blurRadius: 20,
          ),
        ],
      ),
      child: InkWell(
        child: Center(child: icon),
        onTap: () {
          if (_recordState == RecordState.stop) {
            setState(() {
              isRecording = true;
            });
            _start();
          } else if (_recordState == RecordState.record) {
            (_recordState == RecordState.pause) ? _resume() : _pause();
          } else if (_recordState == RecordState.pause) {
             _resume();
          }
        },
      ),
    );
  }

  Widget _buildDeleteButton() {
    return IconButton(
      onPressed: () {
        if (_recordState != RecordState.stop) {
          setState(() {
            isRecording = false;
          });
          _stopAndDelete();
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
      ),
      icon: const Icon(
        Icons.backspace,
        color: Color(0xFF354271),

      ),
    );
  }
  Widget _buildText() {
    if (_recordState != RecordState.stop) {
      return _buildTimer();
    }

    return const Text("");
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style:  TextStyle(color: Styles.primaryColor),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }




  Widget _buildPauseResumeControl() {
    late Icon icon;
    late Color color;

    if (_recordState == RecordState.stop) {
      return const SizedBox.shrink();
    } else if (_recordState == RecordState.record) {
      icon = Icon(Icons.pause, color: Colors.white, size: widget.iconSize);
      color = Styles.primaryColor;
    } else {
      icon = Icon(Icons.mic, color: Styles.primaryColor, size: widget.iconSize);
      color = Colors.white;
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            (_recordState == RecordState.pause) ? _resume() : _pause();
          },
        ),
      ),
    );
  }


  Widget _buildRecordStopControl() {
    late Icon icon;
    late Color color;

    if (_recordState != RecordState.stop) {
      icon =  Icon(Icons.stop, color: Colors.red, size: widget.iconSize);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.mic, color: Styles.primaryColor, size: widget.iconSize);
      color = Colors.white;
    }

    return  Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow:  [
          BoxShadow(
            color: Colors.white.withOpacity(0.42),
            blurRadius: 20,
          ),
        ],
      ),
      child: InkWell(
        child: Center(child: icon),
        onTap: () {
          (_recordState != RecordState.stop) ? _stop() : _start();
        },
      ),
    );

  }



}