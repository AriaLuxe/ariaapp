
import 'package:ariapp/app/infrastructure/data_sources/voice_clone_data_provider.dart';
import 'package:ariapp/app/presentation/voice/bloc/voice_bloc.dart';
import 'package:ariapp/app/presentation/voice/voice_clone/bloc/voice_clone_bloc.dart';
import 'package:ariapp/app/presentation/voice/voice_clone/question_response.dart';
import 'package:ariapp/app/presentation/voice/voice_screen.dart';
import 'package:ariapp/app/presentation/voice/widgets/question_background.dart';
import 'package:ariapp/app/presentation/widgets/custom_button_voice_clone.dart';
import 'package:ariapp/app/presentation/widgets/custom_dialog_accept.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class VoiceTrainingFinish extends StatefulWidget {
  const VoiceTrainingFinish({super.key});

  @override
  State<VoiceTrainingFinish> createState() => _VoiceTrainingFinishState();
}

class _VoiceTrainingFinishState extends State<VoiceTrainingFinish> {

  bool isLoadingClone = false;
  @override
  Widget build(BuildContext context) {

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
                          padding: const EdgeInsets.only(top:10.0, left: 10),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                  final voiceCloneBloc = BlocProvider.of<VoiceCloneBloc>(context);
                                  voiceCloneBloc.backAudio();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration:  BoxDecoration(
                                    border: Border.all(color: Colors.black,),
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFFFFFFF).withOpacity(0.52),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.1,
                              ),
                              const Text('Entrenamiento de voz',style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24
                              ),),
                            ],
                          ),
                        ),

                        const QuestionResponse(question: '¿Cúal es tu lugar favorito o ideal para pasar un buen fin de semana?', namePath: 'sexta_pregunta',),
                        const SizedBox(
                            height: 10
                        ),
                        const QuestionResponse(question: 'Describe brevemente a tu persona favorita o al quien mas aprecias', namePath: 'septima_pregunta',),
                        const SizedBox(
                            height: 10
                        ),
                        const QuestionResponse(question: '¿Cómo son tus expresiones de saludo? ej. Hola, que tal, habla, en que andas...', namePath: 'octava_pregunta',),
                        const SizedBox(
                            height: 10
                        ),
                        const QuestionResponse(question: 'Imagina que te acabo de regalar lo que más deseas. Agradeceme', namePath: 'novena_pregunta',),
                        const SizedBox(
                            height: 10
                        ),
                        const QuestionResponse(question: '¿Cómo son tus expresiones de afirmación? Ej. Ok, vava, dale, queda, oka, esta bien...', namePath: 'decima_pregunta',),
                        const SizedBox(
                            height: 10
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width*0.5,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 20),
                                child:isLoadingClone? const Center(child: CircularProgressIndicator(),)
                                    : CustomButtonVoiceClone(text: 'Crear voz',
                                    onPressed: ()async{
                                      setState(() {
                                        isLoadingClone = true;
                                      });
                                      final voiceCloneBloc = BlocProvider.of<VoiceCloneBloc>(context);
                                      final voiceBloc = BlocProvider.of<VoiceBloc>(context);

                                      if(voiceCloneBloc.state.audioPaths.length == 10){
                                        final voiceCloneDataProvider = VoiceCloneDataProvider();
                                        await voiceCloneDataProvider.cloneVoice(state.audioPaths);
                                        voiceBloc.showView(true);
                                        voiceCloneBloc.clearPaths();
                                        setState(() {
                                          isLoadingClone = false;
                                        });
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const VoiceScreen()));

                                      }else{
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomDialogAccept(
                                              text: 'Por favor responda todas las preguntas',
                                              onAccept: () {
                                                setState(() {
                                                  isLoadingClone = false;
                                                });
                                                Navigator.pop(context);
                                              },

                                            );
                                          },
                                        );
                                      }
                                    }, width: 0.8),
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
