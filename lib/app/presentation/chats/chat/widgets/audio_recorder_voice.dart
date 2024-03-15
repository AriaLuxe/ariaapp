import 'package:animate_do/animate_do.dart';
import 'package:ariapp/app/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:open_settings/open_settings.dart';

class AudioRecorderView extends StatefulWidget {
  final Function(String filePath) onSaved;

  const AudioRecorderView({Key? key, required this.onSaved}) : super(key: key);

  @override
  State<AudioRecorderView> createState() => _AudioRecorderViewState();
}

class _AudioRecorderViewState extends State<AudioRecorderView> {
  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String? _audioPath;

  void _startRecording() async {
    final dir = await getTemporaryDirectory();
    _audioPath = '${dir.path}/tmp_audio.m4a';

    await _audioRecorder.start(path: _audioPath!, const RecordConfig());

    setState(() {
      _isRecording = true;
    });
  }

  void _stopRecording() async {
    await _audioRecorder.stop();

    widget.onSaved(_audioPath!);

    setState(() {
      _isRecording = false;
    });
  }

  void _cancelRecording() async {
    await _audioRecorder.stop();

    _audioPath = null;

    setState(() {
      _isRecording = false;
    });
  }

  bool _hasMicPermission = false;

  void _checkMicPermission() async {
    final status = await Permission.microphone.request();
    setState(() {
      _hasMicPermission = (status == PermissionStatus.granted);
    });
  }

  void _showPermissionRationale() {
    OpenSettings.openAppSetting();
  }

  @override
  void initState() {
    super.initState();
    _checkMicPermission();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasMicPermission) {
      return Center(
        child: Column(
          children: [
            const Text("Necesitamos acceso al micrófono"),
            ElevatedButton(
              onPressed: _showPermissionRationale,
              child: const Text("Habilitar micrófono"),
            )
          ],
        ),
      );
    }
    return RecordControl(
      isRecording: _isRecording,
      onStart: _startRecording,
      onStop: _stopRecording,
      onCancel: _cancelRecording,
    );
  }
}

class RecordControl extends StatefulWidget {
  final bool isRecording;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onCancel;

  const RecordControl({
    Key? key,
    required this.isRecording,
    required this.onStart,
    required this.onStop,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<RecordControl> createState() => _RecordControlState();
}

class _RecordControlState extends State<RecordControl> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) {
        widget.onStart();
      },
      onLongPressEnd: (_) {
        widget.onStop();
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.13,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(23), topRight: Radius.circular(23)),
          color: Styles.primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.isRecording
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Text(
                      'Grabando audio',
                      style: TextStyle(color: Styles.primaryColor),
                    ),
                  )
                : const SizedBox(),
            widget.isRecording
                ? const SizedBox()
                : const Divider(color: Color(0xFF354271), thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.backspace,
                      color: widget.isRecording
                          ? Styles.primaryColor
                          : Colors.grey),
                  onPressed: widget.isRecording ? widget.onCancel : null,
                ),
                widget.isRecording
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Styles.primaryColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: IconButton(
                            icon: Flash(
                              duration: const Duration(seconds: 2),
                              infinite: true,
                              child:
                                  const Icon(Icons.pause, color: Colors.white),
                            ),
                            onPressed: widget.onStop,
                          ),
                        ),
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 0,
                              blurRadius: 15,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.mic, color: Styles.primaryColor),
                          onPressed: widget.onStart,
                        ),
                      ),
                IconButton(
                  icon: Icon(Icons.send,
                      color: widget.isRecording
                          ? Styles.primaryColor
                          : Colors.grey),
                  onPressed: widget.isRecording
                      ? null
                      : () {}, // You can handle send action here
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
