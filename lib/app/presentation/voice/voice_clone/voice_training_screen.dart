import 'package:ariapp/app/presentation/voice/voice_clone/bloc/voice_clone_bloc.dart';
import 'package:ariapp/app/presentation/voice/voice_clone/question_response.dart';
import 'package:ariapp/app/presentation/voice/voice_clone/voice_training_finish.dart';
import 'package:ariapp/app/presentation/voice/widgets/question_background.dart';
import 'package:ariapp/app/presentation/widgets/custom_dialog_accept.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/custom_button.dart';

class VoiceTraining extends StatefulWidget {
  const VoiceTraining({super.key});

  @override
  State<VoiceTraining> createState() => _VoiceTrainingState();
}

class _VoiceTrainingState extends State<VoiceTraining> {
  @override
  Widget build(BuildContext context) {
    final voiceBloc = BlocProvider.of<VoiceCloneBloc>(context);
    return BlocBuilder<VoiceCloneBloc, VoiceCloneState>(
      builder: (context, state) {
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
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  voiceBloc.clearPaths();

                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFFFFFFF)
                                        .withOpacity(0.52),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),
                              const Text(
                                'Entrenamiento de voz',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                        const QuestionResponse(
                          question:
                              '¿Cúal es tu nombre y como te gusta que te llamen?',
                          namePath: 'primera_pregunta',
                        ),
                        const SizedBox(height: 10),
                        const QuestionResponse(
                          question:
                              '¿Cúal es tu comida favorita y por qué?(Sé breve, por favor)',
                          namePath: 'segunda_pregunta',
                        ),
                        const SizedBox(height: 10),
                        const QuestionResponse(
                          question:
                              '¿Cúal es tu canción favorita  y por qué?(Sé breve, por favor)',
                          namePath: 'tercera_pregunta',
                        ),
                        const SizedBox(height: 10),
                        const QuestionResponse(
                          question:
                              '¿Puedes contarme un chiste o una experiencia que te hizo reír mucho?',
                          namePath: 'cuarta_pregunta',
                        ),
                        const SizedBox(height: 10),
                        const QuestionResponse(
                          question:
                              '¿Cómo te sentirías si ganaras un premio sorpresa en este momento?',
                          namePath: 'quinta_pregunta',
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 20),
                                child: CustomButton(
                                    text: 'Continuar',
                                    onPressed: () {
                                      final voiceBloc =
                                          BlocProvider.of<VoiceCloneBloc>(
                                              context);

                                      if (voiceBloc.state.audioPaths.length >=
                                          5) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const VoiceTrainingFinish()));
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomDialogAccept(
                                              text:
                                                  'Por favor responda todas las preguntas',
                                              onAccept: () {
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                        );
                                      }
                                    },
                                    width: 0.8),
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
      },
    );
  }
}
