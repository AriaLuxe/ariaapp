import 'package:ariapp/app/config/styles.dart';
import 'package:ariapp/app/presentation/chats/chat/widgets/custom_icon_button.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';


class PlayerMessage extends StatefulWidget {
  final String audioPath;
  final void Function() onDelete;

  const PlayerMessage({
    Key? key,
    required this.audioPath, required this.onDelete,
  }) : super(key: key);

  @override
  PlayerMessageState createState() => PlayerMessageState();
}

class PlayerMessageState extends State<PlayerMessage> {
  late AudioPlayer _audioPlayer;
  late ConcatenatingAudioSource _audioSource;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioSource = ConcatenatingAudioSource(children: [
      AudioSource.uri(Uri.file(widget.audioPath)),
    ]);

    _initAudioPlayer();
  }

  void _initAudioPlayer() async {
    try {
      await _audioPlayer.setAudioSource(_audioSource);
    } catch (e) {
      print("Error al cargar la fuente de audio: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: size.width*0.7,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: Styles.primaryColor,
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StreamBuilder(
            stream: _audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;

              if (!(playing ?? false)) {
                return CustomIconButton(
                  background: Colors.white,
                  onPressed: _audioPlayer.play,
                  iconColor: Styles.primaryColor,
                  icon: Icons.play_arrow,
                );
              } else if (processingState != ProcessingState.completed) {
                return CustomIconButton(
                  background: Colors.white,
                  onPressed: _audioPlayer.pause,
                  iconColor: Styles.primaryColor,
                  icon: Icons.pause,
                );
              }
              /*  return  CustomIconButton(
                  background: Colors.white,
                  onPressed: widget.audioPlayer.play,
                   icon: Icons.play_arrow,
                  iconColor: Styles.primaryColor,
*/              return CustomIconButton(
                background: Colors.white,
                onPressed: () {
                  // Reiniciar la reproducción desde el principio
                  _audioPlayer.seek(Duration.zero);
                  _audioPlayer.play();
                },
                icon: Icons.play_arrow,
                iconColor: Styles.primaryColor,
              );

              //);
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width:size.width * 0.35,
                child: StreamBuilder<PositionData>(
                  stream: _audioPlayer.positionStream.map((position) =>
                      PositionData(
                        position,
                        position,
                        _audioPlayer.duration ?? Duration.zero,
                      )
                  ),
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return ProgressBar(
                      barHeight: 3,
                      thumbRadius: 5,
                      baseBarColor: Colors.white,
                      bufferedBarColor: Colors.white,
                      progressBarColor: const Color(0xFF5368d6),
                      thumbColor: const Color(0xFF5368d6),
                      timeLabelTextStyle: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      progress: positionData?.position ?? Duration.zero,
                      buffered: positionData?.bufferedPosition ?? Duration.zero,
                      total: positionData?.duration ?? Duration.zero,
                      onSeek: _audioPlayer.seek,
                    );
                  },
                ),
              ),
            ],
          ),

        ],
      ),
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