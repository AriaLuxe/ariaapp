import 'dart:io';

import 'package:ariapp/app/config/styles.dart';
import 'package:ariapp/app/infrastructure/services/camera_gallery_service_impl.dart';
import 'package:ariapp/app/presentation/layouts/widgets/header.dart';
import 'package:ariapp/app/presentation/voice/widgets/question_scrollable_view.dart';
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
             FilledButton(onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionScrollableView()));
             }, child: Text('clonar'))

            ],
          ),
        ))
      ],
    );
  }
}
