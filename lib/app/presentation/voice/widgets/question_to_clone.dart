import 'package:ariapp/app/presentation/chats/chat/widgets/audio_recorder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'question_background.dart';

class QuestionToClone extends StatefulWidget {
    const QuestionToClone({super.key, required this.question});
    final String question;
  @override
  State<QuestionToClone> createState() => _QuestionToCloneState();
}

class _QuestionToCloneState extends State<QuestionToClone> {

   String? audioPath = '';
    @override
    Widget build(BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/future.jpeg'),
            fit: BoxFit.cover
          ),
        ),
        child: Stack(
          children: [

            QuestionBackground(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: _QuestionString(
                    question: widget.question,
                  ),
                ),
               const SizedBox(
                 height: 50,
               ),
               AudioRecorder(iconSize: 60,onStop: (path){

                      print('path enviado');
                      print(path);
                      if (kDebugMode) print('Recorded file path: $path');
                      audioPath = path;

                     // chatBloc.isRecording(true);

                      //showPlayer = true;

                  }),

              ],
            ),
          ],
        ),
      );
    }
}


class _QuestionString extends StatelessWidget {
  const _QuestionString({required this.question});
  final String question;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: MediaQuery.of(context).size.width*0.6,
      child: Text(question, maxLines: 2,
        style:  textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),

      ),
    );
  }
}
