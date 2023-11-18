import 'dart:async';

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/styles.dart';
import '../bloc/chat_bloc.dart';

class AudioPlayers extends StatefulWidget {
  /// Path from where to play recorded audio
  final String source;
 // final int chatId;
  /// Callback when audio file should be removed
  /// Setting this to null hides the delete button
  final VoidCallback onDelete;

  final void Function() onSent;
  final bool isChat; // Agrega la variable isChat


  const AudioPlayers({
    Key? key,
    required this.source,
    required this.onDelete,  required this.onSent,
    required this.isChat, // Incluye isChat en el constructor

  }) : super(key: key);

  @override
  AudioPlayersState createState() => AudioPlayersState();
}

class AudioPlayersState extends State<AudioPlayers> {
  static const double _controlSize = 35;
  static const double _deleteBtnSize = 18;

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Styles.primaryColor,
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              _buildControl(),
              Column(

                children: [
                  _buildSlider(constraints.maxWidth),
                  SizedBox(
                      child: Text(
                        '${_duration ?? Duration.zero} / ${_duration?.inSeconds?? '00:00'}',

                        style: const TextStyle(
                            fontSize: 12,color: Colors.white
                        ),)),

                ],
              ),
              IconButton(
                icon: const Icon(Icons.backspace,
                    color: Colors.white, size: _deleteBtnSize),
                onPressed: () {
                  if (_audioPlayer.state == ap.PlayerState.playing) {
                    stop().then((value) => widget.onDelete());
                  } else {
                    widget.onDelete();
                  }
                },
              ),

            ],
          ),
        );
      },
    );
  }

  Widget _buildControl() {
    Icon icon;
    Color color;

    if (_audioPlayer.state == ap.PlayerState.playing) {
      icon = const Icon(Icons.pause, color: Color(0xFF354271), size: 25);
      color = Colors.white;
    } else {
      icon = const Icon(Icons.play_arrow, color: Color(0xFF354271), size:25);
      color = Colors.white;
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child:
          SizedBox(width: _controlSize, height: _controlSize, child: icon),
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
        activeColor: const Color(0xFF5368d6),
        inactiveColor: Colors.white,
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

  Future<void> play() {
    print(widget.source);
    return _audioPlayer.play(
      kIsWeb ? ap.UrlSource(widget.source) : ap.DeviceFileSource(widget.source),
    );
  }

  Future<void> pause() => _audioPlayer.pause();

  Future<void> stop() => _audioPlayer.stop();
}