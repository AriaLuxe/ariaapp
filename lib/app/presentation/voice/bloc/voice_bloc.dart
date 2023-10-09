import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'voice_event.dart';
part 'voice_state.dart';

class VoiceBloc extends Bloc<VoiceEvent, VoiceState> {
  VoiceBloc() : super(const VoiceState()) {
    on<VoiceEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ShowPlayer>(_onShowPlayer);
    on<CollectAudio>(_onAddedPath);
  }


  Future<void> _onShowPlayer(
      ShowPlayer event,
      Emitter<VoiceState> emit
      ) async
  {
    try {
      if (event.isRecording) {
        emit(state.copyWith(isRecording: true));
      } else {
        emit(state.copyWith(isRecording: false));
      }
      print(event.isRecording);

    } catch (e) {
      emit(state.copyWith(isRecording: false));
    }
  }
  void isRecording(bool isRecording) {
    add(ShowPlayer(isRecording));
  }

Future<void> _onAddedPath(
    CollectAudio event,
    Emitter<VoiceState> emit
    )async {
    try
    {
      final List<String> paths = List.from(state.audioPaths)..add(event.path);
      emit(state.copyWith(audioPaths: paths, voiceStatus: VoiceStatus.success));

    }catch (e){
      emit(state.copyWith(voiceStatus: VoiceStatus.error));
    }

    }
  void collectAudio(String path) {
    add(CollectAudio(path));
  }

  Future<void> _onCloneVoice(
  CloneVoice event,
      Emitter<VoiceState> emit
      ) async{
    try {

    }
    catch(e){
      emit(state.copyWith(voiceStatus: VoiceStatus.error));
    }
  }

}

