import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../config/styles.dart';
import 'custom_icon_button.dart';

class AudioMessageContent extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final String audioUrl;
  const AudioMessageContent({
    super.key,
    required this.audioPlayer,
    required this.audioUrl,
  });

  @override
  AudioMessageContentState createState() => AudioMessageContentState();
}

class AudioMessageContentState extends State<AudioMessageContent> {

  late bool isReadyToPlay; // Add this variable

  @override
  void initState() {
    super.initState();
    isReadyToPlay = false;
    _initialize();
  }

  Future<void> _initialize() async {
    widget.audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.ready) {
        setState(() {
          isReadyToPlay = true;
        });
      }
    });
  }


  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        widget.audioPlayer.positionStream,
        widget.audioPlayer.bufferedPositionStream,
        widget.audioPlayer.durationStream,
            (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: size.width * 0.6,

      child:isReadyToPlay? Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StreamBuilder(
            stream: widget.audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;

              if (!(playing ?? false)) {
                return CustomIconButton(
                  background: Colors.white,
                  onPressed: widget.audioPlayer.play,
                  iconColor: Styles.primaryColor,
                  icon: Icons.play_arrow,
                );
              } else if (processingState != ProcessingState.completed) {
                return CustomIconButton(
                  background: Colors.white,
                  onPressed: widget.audioPlayer.pause,
                  iconColor: Styles.primaryColor,
                  icon: Icons.pause,
                );
              }
            return CustomIconButton(
                background: Colors.white,
                onPressed: () {
                  // Reiniciar la reproducción desde el principio
                  widget.audioPlayer.seek(Duration.zero);
                  widget.audioPlayer.play();
                },
                icon: Icons.play_arrow,
                iconColor: Styles.primaryColor,
              );

              //);
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * 0.4,
                child: StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return ProgressBar(
                      barHeight: 3,
                      thumbRadius: 5,
                      baseBarColor: Colors.white,
                      bufferedBarColor: Colors.white,
                      progressBarColor: Styles.primaryColor,
                      thumbColor: const Color(0xFF5368d6),
                      timeLabelTextStyle: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                      progress: positionData?.position ?? Duration.zero,
                      buffered: positionData?.bufferedPosition ?? Duration.zero,
                      total: positionData?.duration ?? Duration.zero,
                      onSeek: widget.audioPlayer.seek,
                    );
                  },
                ),
              ),
              SizedBox(height: size.height * 0.003),
            ],
          )
        ],
      ): const Center(child: CircularProgressIndicator()),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
  const PositionData(
      this.position,
      this.bufferedPosition,
      this.duration,
      );
}