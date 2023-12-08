import 'dart:async';
import 'dart:developer';

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
    on<BackAudio>(_onBackPath);

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

  void audioResponse(bool isThereAudio) {
    add(ShowAudioResponse(isThereAudio));
  }

  void recordResponse(bool isRecordingResponse) {
    add(ShowRecording(isRecordingResponse));
  }

  Future<void> _onClearPaths(
      ClearPaths event, Emitter<VoiceCloneState> emit) async {
    try {
      emit(state.copyWith(audioPaths: []));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onAddedPath(
      CollectAudio event, Emitter<VoiceCloneState> emit) async {
    try {
      final List<String> paths = List.from(state.audioPaths)..add(event.path);
      emit(state.copyWith(audioPaths: paths));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onDeletePath(
      DeleteAudio event, Emitter<VoiceCloneState> emit) async {
    try {
      final List<String> paths = List.from(state.audioPaths);
      if (paths.isNotEmpty) {
        paths.removeLast();
        emit(state.copyWith(
          audioPaths: paths,
        ));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onBackPath(
      BackAudio event, Emitter<VoiceCloneState> emit) async {
    try {
      final List<String> paths = List.from(state.audioPaths);

      for (int i = paths.length - 1; i >= 0; i--) {
        if (i > 4) {
          paths.removeAt(i);
        }
      }
      emit(state.copyWith(
        audioPaths: paths,
      ));
    } catch (e) {
      log(e.toString());
    }
  }

  void backAudio() {
    add(const BackAudio());
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
