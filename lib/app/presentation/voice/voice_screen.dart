import 'dart:io';

import 'package:ariapp/app/config/base_url_config.dart';
import 'package:ariapp/app/infrastructure/data_sources/voice_clone_data_provider.dart';
import 'package:ariapp/app/infrastructure/repositories/voice_repository.dart';
import 'package:ariapp/app/presentation/chats/chat/widgets/audio_player_widget.dart';
import 'package:ariapp/app/presentation/chats/chat/widgets/audio_players.dart';
import 'package:ariapp/app/presentation/chats/chat_list/bloc/chat_list_bloc.dart';
import 'package:ariapp/app/presentation/voice/edit_voice/edit_voice.dart';
import 'package:ariapp/app/presentation/voice/voice_clone/player_response.dart';
import 'package:ariapp/app/presentation/voice/voice_clone/player_response_network.dart';
import 'package:ariapp/app/presentation/voice/voice_clone/voice_clone.dart';
import 'package:ariapp/app/presentation/widgets/custom_dialog.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:ariapp/app/config/styles.dart';
import 'package:ariapp/app/presentation/voice/widgets/question_scrollable_view.dart';
import 'package:ariapp/app/presentation/widgets/custom_button_blue.dart';
import 'package:ariapp/app/presentation/widgets/custom_button_follow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:path_provider/path_provider.dart';

import '../chats/chat/widgets/audio_message.dart';
import 'bloc/voice_bloc.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});


  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {

  bool isEditingConfiguration = false;
  bool testAudio = false;

final TextEditingController _testVoice = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final voiceBloc = BlocProvider.of<VoiceBloc>(context);
    voiceBloc.fetchProfileVoice();

    return BlocBuilder<VoiceBloc, VoiceState>(
  builder: (context, state) {
    return state.isThereAudio ? Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Perfil de voz',
                          style: TextStyle(color: Colors.white,
                              fontSize: 29),
                        ),
                      ),
                      const SizedBox(height: 15),

                      const Text(
                        'Información',
                        style: TextStyle(
                            color: Colors.white, fontSize: 19),
                      ),
                      const SizedBox(height: 10),
                      buildInfoTile(
                          Icons.description, 'title', state.title),
                      const SizedBox(height: 5),
                      buildInfoTile(Icons.description, 'Descripción',
                          state.description),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          const Text(
                            'Configuración    ',
                            style: TextStyle(
                                color: Colors.white, fontSize: 19),
                          ),
                          isEditingConfiguration
                              ? const SizedBox()
                              : SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.2,

                              child: CustomButtonFollow(
                                  text: 'Editar', onPressed: () {
                                setState(() {
                                  isEditingConfiguration =
                                  !isEditingConfiguration;
                                });
                              }, color: const Color(0xFF5368d6)))

                        ],
                      ),

                      const SizedBox(height: 10),

                      isEditingConfiguration ? Container(
                        decoration: BoxDecoration(

                            color: const Color(0xFF354271).withOpacity(
                                0.97),
                            borderRadius: BorderRadius.circular(25)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Slider(
                                activeColor: const Color(0xFF9269BE),
                                inactiveColor: const Color(0xFF5368d6),
                                value: double.parse(state.stability),
                                max: 1.0,
                                label: '${(double.parse(state.stability) *
                                    100).toStringAsFixed(0)}%',
                                onChanged: (double value) {
                                  voiceBloc.updateStability(value);
                                },
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.0,),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text('Mas variable', style: TextStyle(
                                        color: Colors.white),),
                                    Text('Mas estable', style: TextStyle(
                                        color: Colors.white),),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ) : buildInfoTile(
                        Icons.tune, 'Estabilidad', '${((double.tryParse(
                          state.stability) ?? 0) * 100).toStringAsFixed(
                          1)}%',
                      ),
                      const SizedBox(height: 5),

                      isEditingConfiguration ? Container(
                        decoration: BoxDecoration(

                            color: const Color(0xFF354271).withOpacity(
                                0.97),
                            borderRadius: BorderRadius.circular(25)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Slider(
                                activeColor: const Color(0xFF9269BE),
                                inactiveColor: const Color(0xFF5368d6),
                                value: double.parse(state.similarity),
                                max: 1.0,
                                // Asegúrate de que el valor máximo sea 1.0
                                label: '${(double.parse(
                                    state.similarity) * 100)
                                    .toStringAsFixed(0)}%',
                                onChanged: (double value) {
                                  voiceBloc.updateSimilarity(value);
                                },
                              ),

                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.0,),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text('Bajo', style: TextStyle(
                                        color: Colors.white),),
                                    Text('Alto', style: TextStyle(
                                        color: Colors.white),),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ) : buildInfoTile(
                        Icons.tune, 'Aumento de similitud', '${((double
                          .tryParse(state.similarity) ?? 0) * 100)
                          .toStringAsFixed(1)}%',),
                      const SizedBox(height: 15),

                      isEditingConfiguration ? CustomButtonBlue(
                          text: 'Guardar Cambios', onPressed: () async {
                        setState(() {
                          isEditingConfiguration =
                          !isEditingConfiguration;
                        });
                        final voiceRepository = GetIt.instance<
                            VoiceRepository>();
                        int? userId = await SharedPreferencesManager
                            .getUserId();
                        //TODO
                        voiceRepository.editSettingsVoiceClone(4,
                            double.parse(state.stability),
                            double.parse(state.similarity));
                      }, width: 0.5) :
                      const SizedBox(),
                      const SizedBox(height: 15),

                      const Text(
                        'Probar voz',
                        style: TextStyle(
                            color: Colors.white, fontSize: 19),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xFFebebeb).withOpacity(
                              0.26),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: _testVoice,
                            cursorColor: Colors.white,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior
                                  .never,

                              labelText: 'Ingrese texto aquí',
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      testAudio ? PlayerResponseNetwork(
                        audioUrl: 'https://uploadsaria.blob.core.windows.net/files/${state
                            .urlAudioTest}',
                        //time: DateTime.now(),
                        //senderId: 1,
                        //isMe: true,
                        // url: 'https://uploadsaria.blob.core.windows.net/files/',
                        onDelete: () {},
                      ) : SizedBox(),
                      const SizedBox(height: 10),

                      CustomButtonBlue(
                        text: testAudio
                            ? 'Nueva prueba'
                            : 'Generar audio',
                        onPressed: () {
                          if (testAudio) {
                            _testVoice.clear();
                          }
                          voiceBloc.testAudio(_testVoice.text);
                          print(state.urlAudioTest);
                          print('entre?');
                          setState(() {
                            testAudio = !testAudio;
                          });
                        },
                        width: 0.5,
                      ),
                      const SizedBox(height: 10),

                      buildOptionsContainer(voiceBloc,
                          state.title, state.description,state.voiceId),
                    ],
                  ),

                ),
              ),
            ))): loadBody();
  }
    );


  }

  Widget buildInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      leading: Icon(icon, color: Colors.white, size: 36),
      tileColor: const Color(0xFF354271).withOpacity(0.97),
      textColor: Colors.white,
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {},
    );
  }

  Widget buildOptionsContainer(voiceBloc, String title, String description, String voiceId) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: const Color(0xFFebebeb).withOpacity(0.26),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [

            const SizedBox(height: 6),
            buildOptionTile('Eliminar voz', Icons.delete, Colors.red, (){
              final voiceCloneDataProvider = VoiceCloneDataProvider();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(
                    text: '¿Estás seguro que desea eliminar la voz clonada?',
                    onOk: () async {
                      await voiceCloneDataProvider.deleteVoice(voiceId);
                      Navigator.pop(context);
                      voiceBloc.showView(false);

                      //Navigator.push(context, MaterialPageRoute(builder: (context) => const VoiceClone()));
                    },
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                  );
                },
              );
             // await voiceCloneDataProvider.deleteVoice(voiceId);


            },Colors.red),
          ],
        ),
      ),
    );
  }

  Widget buildOptionTile(String title, IconData icon, Color iconColor,void Function()? onTap,Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF354271).withOpacity(0.97),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ListTile(
        title: Text(
          title,
          style:  TextStyle(color: textColor),
        ),
        trailing: Icon(icon, color: iconColor),
        onTap: onTap,
      ),
    );
  }

  Widget loadBody() {
    return const VoiceClone();
  }
}
