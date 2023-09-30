import 'dart:io';

import 'package:ariapp/app/config/styles.dart';
import 'package:ariapp/app/infrastructure/services/camera_gallery_service_impl.dart';
import 'package:ariapp/app/presentation/layouts/widgets/header.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

import '../../infrastructure/data_sources/voice_clone_data_provider.dart';

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

  Future<void> cloneVoice() async {
    try {
      final voiceDataProvider = VoiceCloneDataProvider();
      // Ruta del archivo de audio MP3
      final File audioFile = File(audioPath!);

      // Ruta del archivo de imagen
      final File imageFile = File('/assets/images/1.jpg');

      await voiceDataProvider.cloneVoice(
        audioFile,
        imageFile,
      );
    } catch (e) {
      print(e);
    }
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
    } catch (e) {
      print(e);
    }
  }

  Future<void> playRecording() async {
    try {
      await audioPlayer.play(UrlSource(audioPath!));
      //await audioPlayer.play(source)
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
                  startRecording();
                },
                child: Text('grabar'),
              ),
              ElevatedButton(
                onPressed: () {
                  stopRecording();
                },
                child: const Text('STOP'),
              ),
              ElevatedButton(
                  onPressed: () {
                    playRecording();
                  },
                  child: Text('reproducir')),
              ElevatedButton(
                  onPressed: () {
                    cloneVoice();
                  },
                  child: Text('clonar')),
              ElevatedButton(
                  onPressed: () async {
                    final photoPath =
                        await CameraGalleryServiceImpl().selectPhoto();
                    if (photoPath == null) return;

                    photoPath;
                  },
                  child: Text('Seleccionar photo')),
              ElevatedButton(
                  onPressed: () async {
                    final photoPath =
                        await CameraGalleryServiceImpl().takePhoto();
                    if (photoPath == null) return;

                    photoPath;
                  },
                  child: Text('tomar photo')),
            ],
          ),
        ))
      ],
    );
  }
}
