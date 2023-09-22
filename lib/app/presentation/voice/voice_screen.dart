import 'package:ariapp/app/config/styles.dart';
import 'package:ariapp/app/presentation/layouts/widgets/header.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String? audioPath = '';
  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    audioRecord.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioPath = path;
      });
      setState(() {
        isRecording = true;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> playRecording() async {
    try {
      Source url = UrlSource(audioPath!);
      await audioPlayer.play(url);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              color: Styles.primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: Column(
              children: [
                Header(
                  title: 'Clona tu voz',
                ),
              ],
            )),
        Expanded(
            child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 90,
                child: Icon(
                  Icons.mic,
                  size: 90,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  isRecording ? startRecording() : stopRecording();
                },
                child: isRecording ? const Text('STOP') : Text('grabar'),
              ),
              if (!isRecording && audioPath != null)
                ElevatedButton(
                    onPressed: () {
                      playRecording();
                    },
                    child: Text('reproducir'))
            ],
          ),
        ))
      ],
    );
  }
}
