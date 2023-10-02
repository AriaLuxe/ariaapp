import 'package:flutter/material.dart';
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
late final AudioPlayer audioPlayer;



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
                Expanded(
                  child: StreamBuilder<PlayerState?>(
                    stream: audioPlayer.playerStateStream,
                    builder: (_, snapshot) {
                      final playerState = snapshot.data;
                      final processingState = playerState?.processingState;
                      final playing = playerState?.playing;
                      if (!(playing ?? false)) {
                        return IconButton(
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
                          onPressed: () async {
                            await audioPlayer.pause();
                          },
                          icon: const Icon(Icons.pause_rounded),
                        );
                      }
                      return const Icon(
                        Icons.play_arrow_rounded,
                        size: 40,
                        color: Colors.yellow,
                      );
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
