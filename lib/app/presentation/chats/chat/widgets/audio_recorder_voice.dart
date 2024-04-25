import 'package:animate_do/animate_do.dart';
import 'package:ariapp/app/config/helpers/custom_dialogs.dart';
import 'package:ariapp/app/config/styles.dart';
import 'package:ariapp/app/infrastructure/repositories/message_repository.dart';
import 'package:ariapp/app/presentation/chats/chat/bloc/chat_bloc.dart';
import 'package:ariapp/app/presentation/chats/chat_list/bloc/chat_list_bloc.dart';
import 'package:ariapp/app/presentation/sign_in/widgets/text_input.dart';
import 'package:ariapp/app/security/user_logged.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:open_settings/open_settings.dart';

class AudioRecorderView extends StatefulWidget {
  final Function(String filePath) onSaved;
  final int chatId;
  final int userReceivedId;

  const AudioRecorderView({
    Key? key,
    required this.onSaved,
    required this.chatId,
    required this.userReceivedId,
  }) : super(key: key);

  @override
  State<AudioRecorderView> createState() => _AudioRecorderViewState();
}

class _AudioRecorderViewState extends State<AudioRecorderView> {
  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String? _audioPath;

  void _startRecording() async {
    final dir = await getTemporaryDirectory();
    _audioPath = '${dir.path}/tmp_audio.m4a';

    await _audioRecorder.start(path: _audioPath!, const RecordConfig());

    setState(() {
      _isRecording = true;
    });
  }

  void _stopRecording() async {
    await _audioRecorder.stop();

    widget.onSaved(_audioPath!);

    setState(() {
      _isRecording = false;
    });
  }

  void _cancelRecording() async {
    await _audioRecorder.stop();

    _audioPath = null;

    setState(() {
      _isRecording = false;
    });
  }

  bool _hasMicPermission = false;

  void _checkMicPermission() async {
    final status = await Permission.microphone.request();
    setState(() {
      _hasMicPermission = (status == PermissionStatus.granted);
    });
  }

  void _showPermissionRationale() {
    OpenSettings.openAppSetting();
  }

  @override
  void initState() {
    super.initState();
    _checkMicPermission();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasMicPermission) {
      return Center(
        child: Column(
          children: [
            const Text("Necesitamos acceso al micrófono"),
            ElevatedButton(
              onPressed: _showPermissionRationale,
              child: const Text("Habilitar micrófono"),
            )
          ],
        ),
      );
    }
    return RecordControl(
      isRecording: _isRecording,
      onStart: _startRecording,
      onStop: _stopRecording,
      onCancel: _cancelRecording,
      chatId: widget.chatId,
      userReceivedId: widget.userReceivedId,
    );
  }
}

class RecordControl extends StatefulWidget {
  final bool isRecording;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onCancel;
  final int chatId;
  final int userReceivedId;

  const RecordControl({
    Key? key,
    required this.isRecording,
    required this.onStart,
    required this.onStop,
    required this.onCancel,
    required this.chatId,
    required this.userReceivedId,
  }) : super(key: key);

  @override
  State<RecordControl> createState() => _RecordControlState();
}

class _RecordControlState extends State<RecordControl> {
  bool _isTyping = false;
  final TextEditingController textMessageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final chatBloc = context.watch<ChatBloc>();
    final chatListBloc = context.watch<ChatListBloc>();
    final userLoggedId = GetIt.instance<UserLogged>().user.id;
    final size = MediaQuery.of(context).size;

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: size.width * 0.7,
                  child: TextInput(
                      errorMessage:
                          state.textMessageInputValidator.errorMessage,
                      maxLines: 3,
                      minLines: 1,
                      onChanged: (message) {
                        context.read<ChatBloc>().add(TextMessage(message));
                        if (message.isNotEmpty) {
                          setState(() {
                            _isTyping = true;
                          });
                        } else {
                          setState(() {
                            _isTyping = false;
                          });
                        }
                      },
                      controller: textMessageController,
                      label: 'Escribe un mensaje...',
                      verticalPadding: 0)),
              const SizedBox(
                width: 20,
              ),
              _isTyping
                  ? Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0,
                            blurRadius: 15,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Styles.primaryColor),
                        onPressed: textMessageController.text.isEmpty
                            ? null
                            : () {
                                chatBloc.messageSent(
                                  widget.chatId,
                                  widget.userReceivedId,
                                  '',
                                  textMessageController.text,
                                  TypeMsg.text,
                                );
                                chatListBloc.chatsFetched();
                                textMessageController.clear();
                              },
                      ),
                    )
                  : GestureDetector(
                      onLongPressStart: (_) {
                        widget.onStart();
                      },
                      onLongPressEnd: (_) {
                        widget.onStop();
                      },
                      child: widget.isRecording
                          ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Styles.primaryColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: IconButton(
                                  icon: Flash(
                                    duration: const Duration(seconds: 2),
                                    infinite: true,
                                    child: const Icon(Icons.pause,
                                        color: Colors.white),
                                  ),
                                  onPressed: widget.onStop,
                                ),
                              ),
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 0,
                                    blurRadius: 15,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon:
                                    Icon(Icons.mic, color: Styles.primaryColor),
                                onPressed: widget.onStart,
                              ),
                            ),
                    ),
              const SizedBox(
                width: 10,
              ),
              state.isReadyToTraining
                  ? Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF5368d6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0,
                            blurRadius: 15,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Styles.primaryColor),
                        onPressed: () async {
                          CustomDialogs().showCustomDialog(
                              context: context,
                              text:
                                  '¿Estás seguro de enviar chat para entrenar?',
                              onOk: () async {
                                final messageRepository =
                                    GetIt.instance<MessageRepository>();
                                await messageRepository.sendTraining(
                                    userLoggedId!, widget.chatId);
                                chatBloc.isReadyToTraining(widget.chatId);

                                Navigator.pop(context);
                              },
                              onCancel: () {
                                Navigator.pop(context);
                              });
                        },
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
