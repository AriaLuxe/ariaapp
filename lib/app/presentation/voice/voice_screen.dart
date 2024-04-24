import 'package:ariapp/app/config/helpers/custom_dialogs.dart';
import 'package:ariapp/app/infrastructure/data_sources/message_data_provider.dart';
import 'package:ariapp/app/infrastructure/data_sources/voice_clone_data_provider.dart';
import 'package:ariapp/app/infrastructure/models/chat_model.dart';
import 'package:ariapp/app/infrastructure/repositories/chat_repository.dart';
import 'package:ariapp/app/infrastructure/repositories/message_repository.dart';
import 'package:ariapp/app/infrastructure/repositories/voice_repository.dart';
import 'package:ariapp/app/presentation/chats/chat/bloc/chat_bloc.dart';
import 'package:ariapp/app/presentation/voice/voice_clone/voice_clone_screen.dart';
import 'package:ariapp/app/presentation/voice/widgets/audio_player_test.dart';
import 'package:ariapp/app/presentation/widgets/custom_button_blue.dart';
import 'package:ariapp/app/presentation/widgets/custom_button_follow.dart';
import 'package:ariapp/app/presentation/widgets/custom_dialog.dart';
import 'package:ariapp/app/presentation/widgets/custom_dialog_accept.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:ariapp/app/security/user_logged.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

import 'bloc/voice_bloc.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  bool isEditingConfiguration = false;
  bool loadingVoiceTest = false;
  bool loadingDeleteVoiceClone = false;

  bool testAudio = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final TextEditingController _testVoice = TextEditingController();

  @override
  void initState() {
    final voiceBloc = BlocProvider.of<VoiceBloc>(context);
    voiceBloc.fetchProfileVoice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final voiceBloc = BlocProvider.of<VoiceBloc>(context);
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<VoiceBloc, VoiceState>(builder: (context, state) {
      return state.isThereAudio
          ? Scaffold(
              body: SingleChildScrollView(
                  child: SafeArea(
              child: Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanDown: (_) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    width: size.width * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Perfil de voz',
                            style: TextStyle(color: Colors.white, fontSize: 29),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Información',
                          style: TextStyle(color: Colors.white, fontSize: 19),
                        ),
                        const SizedBox(height: 10),
                        buildInfoTile(
                            Icons.description, 'Título de voz', state.title),
                        const SizedBox(height: 5),
                        buildInfoTile(Icons.description, 'Descripción',
                            state.description),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const Text(
                              'Configuración    ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 19),
                            ),
                            isEditingConfiguration
                                ? const SizedBox()
                                : SizedBox(
                                    width: size.width * 0.2,
                                    child: CustomButtonFollow(
                                        text: 'Editar',
                                        onPressed: () {
                                          setState(() {
                                            isEditingConfiguration =
                                                !isEditingConfiguration;
                                          });
                                        },
                                        color: const Color(0xFF5368d6)))
                          ],
                        ),
                        const SizedBox(height: 10),
                        isEditingConfiguration
                            ? Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xFF354271)
                                        .withOpacity(0.97),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Slider(
                                        activeColor: const Color(0xFF9269BE),
                                        inactiveColor: const Color(0xFF5368d6),
                                        value: double.parse(state.stability),
                                        max: 1.0,
                                        label:
                                            '${(double.parse(state.stability) * 100).toStringAsFixed(0)}%',
                                        onChanged: (double value) {
                                          voiceBloc.updateStability(value);
                                        },
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Mas variable',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Mas estable',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : buildInfoTile(
                                Icons.tune,
                                'Estabilidad',
                                '${((double.tryParse(state.stability) ?? 0) * 100).toStringAsFixed(1)}%',
                              ),
                        const SizedBox(height: 5),
                        isEditingConfiguration
                            ? Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xFF354271)
                                        .withOpacity(0.97),
                                    borderRadius: BorderRadius.circular(25)),
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
                                        label:
                                            '${(double.parse(state.similarity) * 100).toStringAsFixed(0)}%',
                                        onChanged: (double value) {
                                          voiceBloc.updateSimilarity(value);
                                        },
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Bajo',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Alto',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : buildInfoTile(
                                Icons.tune,
                                'Aumento de similitud',
                                '${((double.tryParse(state.similarity) ?? 0) * 100).toStringAsFixed(1)}%',
                              ),
                        const SizedBox(height: 15),
                        isEditingConfiguration
                            ? CustomButtonBlue(
                                text: 'Guardar Cambios',
                                onPressed: () async {
                                  setState(() {
                                    isEditingConfiguration =
                                        !isEditingConfiguration;
                                  });
                                  final voiceRepository =
                                      GetIt.instance<VoiceRepository>();
                                  int? userId = await SharedPreferencesManager
                                      .getUserId();

                                  voiceRepository.editSettingsVoiceClone(
                                      userId!,
                                      double.parse(state.stability),
                                      double.parse(state.similarity));
                                },
                                width: 0.5)
                            : const SizedBox(height: 15),
                        const Text(
                          'Probar voz',
                          style: TextStyle(color: Colors.white, fontSize: 19),
                        ),
                        const SizedBox(height: 10),
                        if (!testAudio)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: const Color(0xFFebebeb).withOpacity(0.26),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                enabled: !testAudio,
                                controller: _testVoice,
                                cursorColor: Colors.white,
                                decoration: const InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  labelText: 'Ingrese texto aquí',
                                  border: InputBorder.none,
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        if (loadingVoiceTest)
                          const Center(child: CircularProgressIndicator()),
                        testAudio
                            ? AudioPlayerTest(
                                audioUrl:
                                    'https://uploadsaria.blob.core.windows.net/files/${state.urlAudioTest}',
                                //time: DateTime.now(),
                                //senderId: 1,
                                //isMe: true,
                                // url: 'https://uploadsaria.blob.core.windows.net/files/',
                                audioPlayer: _audioPlayer,
                              )
                            : const SizedBox(),
                        const SizedBox(height: 10),
                        if (!loadingVoiceTest)
                          CustomButtonBlue(
                            text: testAudio ? 'Nueva prueba' : 'Generar audio',
                            onPressed: testAudio
                                ? () {
                                    _testVoice.clear();
                                    setState(() {
                                      loadingVoiceTest = false;
                                      testAudio = !testAudio;
                                    });
                                  }
                                : () async {
                                    if (_testVoice.text.isEmpty) {
                                      return;
                                    }
                                    setState(() {
                                      loadingVoiceTest = true;
                                    });
                                    int? userId = await SharedPreferencesManager
                                        .getUserId();
                                    final voiceRepository =
                                        GetIt.instance<VoiceRepository>();
                                    final path = await voiceRepository
                                        .testAudio(userId!, _testVoice.text);
                                    _audioPlayer.setUrl(
                                        'https://uploadsaria.blob.core.windows.net/files/$path');
                                    setState(() {
                                      loadingVoiceTest = false;
                                      testAudio = !testAudio;
                                    });
                                  },
                            width: 0.5,
                          ),
                        const SizedBox(height: 10),
                        buildOptionsContainer(voiceBloc, state.title,
                            state.description, state.voiceId),
                      ],
                    ),
                  ),
                ),
              ),
            )))
          : loadBody();
    });
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

  Widget buildOptionsContainer(
      voiceBloc, String title, String description, String voiceId) {
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    final userLoggedId = GetIt.instance<UserLogged>().user.id;

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
            buildOptionTile('Entrenar oneBot', Icons.construction, Colors.white,
                () async {
              chatBloc.clearMessages();
              chatBloc.dataChatFetched(1);

              final chatsDataProvider = GetIt.instance<ChatRepository>();
              final messagesDataProvider = GetIt.instance<MessageRepository>();

              final response =
                  await chatsDataProvider.createChat(userLoggedId!, 1);

              if (response is ChatModel) {
                await messagesDataProvider.createTraining(
                    userLoggedId, response.chatId!);
                chatBloc.messageFetched(response.chatId!, 0, 12);
                chatBloc.isReadyToTraining(response.chatId!);

                context.push('/chat/${response.chatId!}/${response.chatId!}/1');
              } else if (response == 'This user is not a creator') {
                CustomDialogs().showConfirmationDialog(
                  context: context,
                  title: 'Alerta',
                  content:
                      '¡Oops!\nNo se puede chatear con este usuario, ya que no es creador.',
                  onAccept: () {
                    Navigator.pop(context);
                  },
                );
              } else if (response == 'Same user') {
                CustomDialogs().showConfirmationDialog(
                  context: context,
                  title: 'Alerta',
                  content: '¡Oops!\nNo puedes chatear contigo mismo :c',
                  onAccept: () {
                    Navigator.pop(context);
                  },
                );
              }
            }, Colors.white),
            const SizedBox(
              height: 10,
            ),
            loadingDeleteVoiceClone
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : buildOptionTile('Eliminar voz', Icons.delete, Colors.red, () {
                    setState(() {
                      loadingDeleteVoiceClone = true;
                    });
                    final voiceRepository = GetIt.instance<VoiceRepository>();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialog(
                          text:
                              '¿Estás seguro que desea eliminar la voz clonada?',
                          onOk: () async {
                            Navigator.pop(context);
                            await voiceRepository.deleteVoice(voiceId);
                            setState(() {
                              loadingDeleteVoiceClone = false;
                            });
                            voiceBloc.showView(false);
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => const VoiceClone()));
                          },
                          onCancel: () {
                            Navigator.of(context).pop();
                            setState(() {
                              loadingDeleteVoiceClone = false;
                            });
                          },
                        );
                      },
                    );
                    // await voiceCloneDataProvider.deleteVoice(voiceId);
                  }, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget buildOptionTile(String title, IconData icon, Color iconColor,
      void Function()? onTap, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF354271).withOpacity(0.97),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: textColor),
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
