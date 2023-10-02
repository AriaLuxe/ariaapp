import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../security/user_logged.dart';
import '../chat_screen.dart';

class Messages extends StatefulWidget {
  const Messages({super.key, required this.audioPath, required this.time, required this.senderId});
  final String audioPath;
  final DateTime time;
  final int senderId;
  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final userLogged = GetIt.instance<UserLogged>();

  late final AudioPlayer audioPlayer;
  final isMe = true;
  String url = 'https://uploadsaria.blob.core.windows.net/files/';

  Stream<PositionData> get positionDataStream => Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
    audioPlayer.positionStream,
    audioPlayer.bufferedPositionStream,
    audioPlayer.durationStream,
        (position, bufferedPosition, duration) {
      final validDuration = duration ?? Duration.zero;
      return PositionData(position, bufferedPosition, validDuration);
    },
  );
@override
  void initState() async{
    // TODO: implement initState
 audioPlayer = AudioPlayer()..setUrl('$url${widget.audioPath}');
  super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        margin: isMe
            ? const EdgeInsets.only(top: 8, bottom: 8, left: 80)
            : const EdgeInsets.only(top: 8, bottom: 8, right: 80),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF202248) : const Color(0xffF5F5FF),
          borderRadius: isMe
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
                              await audioPlayer.setUrl('$url+${widget.audioPath}');

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
                        return const LinearProgressIndicator();
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
                        color: isMe ? Theme.of(context).primaryColor: Colors.white,
                        backgroundColor: isMe ? Colors.white : Theme.of(context).primaryColor,

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
                color: isMe ? Colors.white : const Color(0xFF202248),
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
