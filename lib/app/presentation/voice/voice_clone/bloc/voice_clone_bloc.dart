import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


part 'voice_clone_event.dart';
part 'voice_clone_state.dart';

class VoiceCloneBloc extends Bloc<VoiceCloneEvent, VoiceCloneState> {
  VoiceCloneBloc() : super(const VoiceCloneState()) {
    on<VoiceCloneEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ShowRecording>(_onShowRecordResponse);
    on<ShowAudioResponse>(_onShowAudioResponse);
    on<CollectAudio>(_onAddedPath);
    on<DeleteAudio>(_onDeletePath);
    on<ClearPaths>(_onClearPaths);


    //on<GetResponses>(_onGetResponse);
  }


  Future<void> _onShowRecordResponse(
      ShowRecording event,
      Emitter<VoiceCloneState> emit,
      ) async {
    try {
      if (event.isRecording) {
        emit(state.copyWith(isRecording: true));
      } else {
        emit(state.copyWith(isRecording: false));
      }

    } catch (e) {
      emit(state.copyWith(isRecording: false));
    }
  }
  Future<void> _onShowAudioResponse(
      ShowAudioResponse event,
      Emitter<VoiceCloneState> emit,
      ) async {
    try {
      if (event.isThereAudio) {
        emit(state.copyWith(isThereAudio: true));
      } else {
        emit(state.copyWith(isThereAudio: false));
      }

    } catch (e) {
      emit(state.copyWith(isRecording: false));
    }
  }
  void audioResponse(bool isThereAudio){
    add(ShowAudioResponse(isThereAudio));
  }
  void recordResponse(bool isRecordingResponse){
    add(ShowRecording(isRecordingResponse));
  }
  Future<void> _onClearPaths(
      ClearPaths event,
      Emitter<VoiceCloneState> emit
      )async {
    try
    {
      emit(state.copyWith(audioPaths: []));

    }catch (e){
      print(e);
    }
  }
  Future<void> _onAddedPath(
      CollectAudio event,
      Emitter<VoiceCloneState> emit
      )async {
    try
    {
      final List<String> paths = List.from(state.audioPaths)..add(event.path);
      emit(state.copyWith(audioPaths: paths));

    }catch (e){
      print(e);
    }
  }

  Future<void> _onDeletePath(
      DeleteAudio event,
      Emitter<VoiceCloneState> emit
      ) async {
    try {
      final List<String> paths = List.from(state.audioPaths);
      if (paths.isNotEmpty) {
        paths.removeLast();
        emit(state.copyWith(audioPaths: paths, ));
      }
    } catch (e) {
      print(e);
    }
  }
  void deleteAudio() {
    add(const DeleteAudio());
  }
  void collectAudio(String path) {
    add(CollectAudio(path));
  }
  void clearPaths() {
    add(const ClearPaths());
  }
}



