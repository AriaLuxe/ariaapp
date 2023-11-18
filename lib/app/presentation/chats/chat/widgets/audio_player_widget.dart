import 'dart:async';
import 'package:audioplayers/audioplayers.dart' as ap;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;
  final String url;

  const AudioPlayerWidget({
    Key? key,
    required this.audioPath,
    required this.url,
  }) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  static const double _controlSize = 40;

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
    return _audioPlayer.play(ap.UrlSource('${widget.url}${widget.audioPath}'));
  }

  Future<void> pause() => _audioPlayer.pause();

  Future<void> stop() => _audioPlayer.stop();

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
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: const Color(0xFF354271),
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControl(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSlider(20),
                    SizedBox(
                        child: Text(
                          '${_duration ?? Duration.zero} / ${_duration?.inSeconds?? '00:00'}',

                          style: const TextStyle(
                              fontSize: 12,color: Colors.white
                          ),)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

          ],
        ),
      ),
    );
  }
}
