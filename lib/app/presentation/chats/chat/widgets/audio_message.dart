/*import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../chat_screen.dart';

class AudioMessage extends StatefulWidget {
  final String audioPath;
  final DateTime time;
  final int senderId;
  final bool isMe;
  //final AudioPlayer audioPlayer;
  final String url;

  const AudioMessage({
    Key? key,
    required this.audioPath,
    required this.time,
    required this.senderId,
    required this.isMe,
  //  required this.audioPlayer,
    required this.url,
  }) : super(key: key);

  @override
  _AudioMessageState createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  late Stream<PositionData> positionDataStream;
late final AudioPlayer audioPlayer; //= AudioPlayer();



  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();

    positionDataStream = Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
      audioPlayer.positionStream,
      audioPlayer.bufferedPositionStream,
      audioPlayer.durationStream,
          (position, bufferedPosition, duration) {
        final validDuration = duration ?? Duration.zero;
        return PositionData(position, bufferedPosition, validDuration);
      },
    );
    audioPlayer.setUrl('${widget.url}${widget.audioPath}');
  }
@override
  void dispose() {
  audioPlayer.dispose();

  super.dispose();
  }

  @override
  void didUpdateWidget(covariant AudioMessage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    audioPlayer.setUrl('${widget.url}${widget.audioPath}');
  }
  @override
  Widget build(BuildContext context) {
    //audioPlayer.setUrl('${widget.url}${widget.audioPath}');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        margin: widget.isMe
            ? const EdgeInsets.only(top: 8, bottom: 8, left: 80)
            : const EdgeInsets.only(top: 8, bottom: 8, right: 80),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        decoration: BoxDecoration(
          color: widget.isMe ? const Color(0xFF202248) : const Color(0xffF5F5FF),
          borderRadius: widget.isMe
              ? const BorderRadius.only(
            topLeft: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )
              : const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: StreamBuilder<PlayerState?>(
                    stream: audioPlayer.playerStateStream,
                    builder: (_, snapshot) {
                      final playerState = snapshot.data;
                      final processingState = playerState?.processingState;
                      final playing = playerState?.playing;
                      if (!(playing ?? false)) {
                        return IconButton(
                          iconSize: 40.0,

                          onPressed: () async {
                            if (audioPlayer.playing) {
                              await audioPlayer.pause();
                            } else {
                              await audioPlayer.play();
                            }
                          },
                          icon: const Icon(Icons.play_arrow_rounded),
                        );
                      } else if (processingState != ProcessingState.completed) {
                        return IconButton(
                          iconSize: 40.0,

                          onPressed: () async {
                            await audioPlayer.pause();
                          },
                          icon: const Icon(Icons.pause_rounded),
                        );
                      }else {return IconButton(
                        icon: const Icon(Icons.replay),
                        iconSize: 40.0,
                        onPressed: () async {
                          await audioPlayer.seek(Duration.zero);},
                      );
                      }

                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder<PositionData>(
                    stream: positionDataStream,
                    builder: (_, snapshot) {
                      if (!snapshot.hasData) {
                        return  LinearProgressIndicator(
                          backgroundColor: widget.isMe ? Colors.white : Theme.of(context).primaryColor,
                          value: 0.0,
                        );
                      }
                      final positionData = snapshot.data!;
                      final durationMilliseconds = positionData.duration.inMilliseconds;
                      final positionMilliseconds = positionData.position.inMilliseconds;

                      if (durationMilliseconds == 0) {
                        return const LinearProgressIndicator(value: 0.0);
                      }

                      double progressValue = positionMilliseconds / durationMilliseconds;

                      return LinearProgressIndicator(
                        value: progressValue,
                        color: widget.isMe ? Theme.of(context).primaryColor : Colors.white,
                        backgroundColor: widget.isMe ? Colors.white : Theme.of(context).primaryColor,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.time.hour}:${widget.time.minute}',
              style: TextStyle(
                color: widget.isMe ? Colors.white : const Color(0xFF202248),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/


import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:audioplayers/audioplayers.dart';
import 'package:rxdart/rxdart.dart';

class AudioMessage extends StatefulWidget {
  final String audioPath;
  final DateTime time;
  final int senderId;
  final bool isMe;
  final String url;

  const AudioMessage({
    Key? key,
    required this.audioPath,
    required this.time,
    required this.senderId,
    required this.isMe,
    required this.url,
  }) : super(key: key);

  @override
  _AudioMessageState createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  static const double _controlSize = 56;
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

    super.initState();
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
   // print(widget.source);
    return _audioPlayer.play(
     ap.UrlSource('${widget.url}${widget.audioPath}')
    );
  }

  Future<void> pause() => _audioPlayer.pause();

  Future<void> stop() => _audioPlayer.stop();

  Widget _buildControl() {
    Icon icon;
    Color iconColor;
    Color backgroundColor;

    if (_audioPlayer.state == ap.PlayerState.playing) {
      icon = const Icon(Icons.pause, size: 30);
      iconColor = Colors.red;
      backgroundColor = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.play_arrow, size: 30);
      iconColor = widget.isMe ? Colors.white : const Color(0xFF202248);
      backgroundColor = Colors.transparent; // Puedes ajustar esto según tus preferencias.
    }

    return ClipOval(
      child: Material(
        color: backgroundColor,
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


  Widget _buildSlider(double widgetWidth) {
    bool canSetValue = false;
    final duration = _duration;
    final position = _position;

    if (duration != null && position != null) {
      canSetValue = position.inMilliseconds > 0;
      canSetValue &= position.inMilliseconds < duration.inMilliseconds;
    }

    double width = widgetWidth - _controlSize - _deleteBtnSize;
    width -= _deleteBtnSize;

    return SizedBox(
      width: MediaQuery.of(context).size.width*0.4,
      child: Slider(
        activeColor: widget.isMe ? Colors.white : const Color(0xFF202248),
        inactiveColor: widget.isMe ? Colors.white : const Color(0xFF202248),
        onChanged: (v) {
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
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        decoration: BoxDecoration(
          color: widget.isMe ? const Color(0xFF202248) : const Color(0xffF5F5FF),
          borderRadius: widget.isMe
              ? const BorderRadius.only(
            topLeft: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )
              : const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildControl(),
                _buildSlider(20)
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${_duration ?? Duration.zero} / ${_duration?.inSeconds?? '00:00'}',
              style: TextStyle(
                color: widget.isMe ? Colors.white : const Color(0xFF202248),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
