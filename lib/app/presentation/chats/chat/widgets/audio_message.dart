
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:audioplayers/audioplayers.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../config/styles.dart';

class AudioMessage extends StatefulWidget {
  final String audioPath;
  final DateTime time;
  final int senderId;
  final bool isMe;
  final String url;
  final bool isChat;
  const AudioMessage({
    Key? key,
    required this.audioPath,
    required this.time,
    required this.senderId,
    required this.isMe,
    required this.url, required this.isChat,
  }) : super(key: key);

  @override
  _AudioMessageState createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  static const double _controlSize = 40;
  static const double _deleteBtnSize = 24;

  final _audioPlayer = ap.AudioPlayer()..setReleaseMode(ReleaseMode.stop);
  late StreamSubscription<void> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  late StreamSubscription<Duration> _positionChangedSubscription;
  Duration? _position;
  Duration? _duration;

  @override
  void initState() {
    _playerStateChangedSubscription =
        _audioPlayer.onPlayerComplete.listen((state) async {
          await stop();
          _timer?.cancel();

          setState(() {});
        });
    _positionChangedSubscription = _audioPlayer.onPositionChanged.listen(
          (position) => setState(() {
        _position = position;
      }),
    );
    _durationChangedSubscription = _audioPlayer.onDurationChanged.listen(
          (duration) => setState(() {
        _duration = duration;
      }),
    );

    _loadAudio();
    _preloadAudio();

    super.initState();
  }


  void _preloadAudio() async {
    await _audioPlayer.play(
        UrlSource('${widget.url}${widget.audioPath}'),
        position: Duration(seconds: 0)
    );
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _positionChangedSubscription.cancel();
    _durationChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _loadAudio() async {
    await _audioPlayer.play(ap.UrlSource(widget.audioPath));

  }

  Future<void> play() {
    _timer?.cancel();

    _startTimer();
   // print(widget.source);
    return _audioPlayer.play(
     ap.UrlSource('${widget.url}${widget.audioPath}')
    );
  }

  Future<void> pause() async{
  await  _audioPlayer.pause();
  _timer?.cancel();

  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _timer?.cancel();

  }

  Widget _buildControl() {
    Icon icon;
    Color iconColor;
    Color backgroundColor;

    if (_audioPlayer.state == ap.PlayerState.playing) {
      icon = const Icon(Icons.pause, size: 30,color: Color(0xFF354271));
      iconColor = Colors.red;
      backgroundColor = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = const Icon(Icons.play_arrow, size: 30, color: Color(0xFF354271),);
      iconColor = Colors.black;
      backgroundColor = Colors.transparent;
    }

    return ClipOval(
      child: Material(
        color: Colors.white,
        child: InkWell(
          child: SizedBox(width: _controlSize, height: _controlSize, child: icon),
          onTap: () {
            if (_audioPlayer.state == ap.PlayerState.playing) {
              pause();
            } else {
              play();
            }
          },
        ),
      ),
    );
  }
  bool _playing = false;

 Widget _buildSlider(double widgetWidth) {
    bool canSetValue = false;
    final duration = _duration;
    final position = _position;

    if (duration != null && position != null) {
      canSetValue = position.inMilliseconds > 0;
      canSetValue &= position.inMilliseconds < duration.inMilliseconds;

    }
    double width = widgetWidth - _controlSize;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Slider(
        inactiveColor: Colors.white,
        activeColor: const Color(0xFF5368d6),
        onChanged:  (v) {
          if (duration != null) {
            final position = v * duration.inMilliseconds;
            _audioPlayer.seek(Duration(milliseconds: position.round()));
          }
        },
        value: canSetValue && duration != null && position != null
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0,
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        margin: widget.isMe
            ? const EdgeInsets.only(top: 8, bottom: 8, left: 80)
            : const EdgeInsets.only(top: 8, bottom: 8, right: 80),
        decoration: BoxDecoration(
          color:  const Color(0xff354271),
          borderRadius: widget.isMe
              ? const BorderRadius.only(
            topLeft: Radius.circular(40),
            bottomLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          )
              : const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                _buildControl(),
                Column(
                  children: [
                    _buildSlider(20),
                    SizedBox(
                        child: Text(
                          '${_duration ?? Duration.zero} / ${_duration?.inSeconds?? '00:00'}',

                          style: const TextStyle(
                              fontSize: 12,color: Colors.white
                          ),)),
                    _buildText(),

                  ],
                )
              ],
            ),

          ],
        ),
      ),
    );
  }
  int _recordDuration = 0;
  Timer? _timer;
/*
  Widget _buildText() {
    if (_duration != null) {
      final minutes = _duration!.inMinutes;
      final seconds = _duration!.inSeconds.remainder(60);
      final formattedTime = '$minutes:${seconds.toString().padLeft(2, '0')}';

      return Text(formattedTime);
    } else {
      return Text("...");
    }
  }
*/
  Widget _buildText() {
  return _buildTimer();
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
     _recordDuration = 0;

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }

}
