import 'package:ariapp/app/config/styles.dart';
import 'package:ariapp/app/presentation/voice/voice_clone/bloc/voice_clone_bloc.dart';
import 'package:ariapp/app/presentation/voice/voice_clone/player_response.dart';
import 'package:ariapp/app/presentation/voice/voice_clone/response_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionResponse extends StatefulWidget {
  const QuestionResponse({super.key, required this.question, required this.namePath});
  final String question;
  final String namePath;
  @override
  State<QuestionResponse> createState() => _QuestionResponseState();
}

class _QuestionResponseState extends State<QuestionResponse> {
  bool recorded = false;
  String audioPath = '';
  @override
  Widget build(BuildContext context) {
    final voiceBloc = BlocProvider.of<VoiceCloneBloc>(context);

    return Container(
      width: MediaQuery.of(context).size.width*0.8,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.67),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width*0.7,
            child: Text(
              widget.question,style: TextStyle(
                color: Styles.primaryColor,
              fontWeight: FontWeight.bold,

            ),
              textAlign: TextAlign.center,
            ),
          ),
          recorded ? PlayerResponse(audioPath: audioPath, onDelete: () {
            setState(() {
              recorded = false;
              voiceBloc.deleteAudio();
            });
          },):
           ResponseRecord(
             onStop: (String path) {
            audioPath = path;
            print(audioPath);
            voiceBloc.collectAudio(audioPath);
            setState(() {
              recorded = true;
            });
          }, namePath: widget.namePath,),

        ],
      ),
    );
  }
}
