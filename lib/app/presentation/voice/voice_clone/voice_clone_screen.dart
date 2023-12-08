import 'package:ariapp/app/presentation/voice/voice_clone/bloc/voice_clone_bloc.dart';
import 'package:ariapp/app/presentation/voice/voice_clone/voice_training_screen.dart';
import 'package:ariapp/app/presentation/voice/widgets/question_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/custom_button.dart';

class VoiceClone extends StatelessWidget {
  const VoiceClone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/future.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,

        child: SafeArea(
          child: Stack(
            children: [
              QuestionBackground(),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.7,
                        child: const Text(
                          'DESCUBRE EL PODER DE TU VOZ',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.2,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.7,
                        child: const Padding(
                          padding:  EdgeInsets.all(10.0),
                          child:  Text('El primer paso para entrenar tu voz con Inteligencia Artificial consiste en responder 10 preguntas para que AIA pueda aprender y familiarizarse con tu voz. Imagina que estás teniendo una conversación amigable. Así la entonación de tu voz será completamente natural',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18
                            ),
                            textAlign: TextAlign.start,

                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.01,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width*0.5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30.0,horizontal: 20),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0, 0),
                                      blurRadius: 4,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),child: CustomButton(text: 'Comenzar', onPressed: (){

                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const VoiceTraining()));
                            }, width: 0.8)),
                          )),
                    ),
                    ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

