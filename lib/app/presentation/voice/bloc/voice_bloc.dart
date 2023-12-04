import 'dart:async';
import 'dart:convert';

import 'package:ariapp/app/infrastructure/repositories/voice_repository.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'voice_event.dart';
part 'voice_state.dart';

class VoiceBloc extends Bloc<VoiceEvent, VoiceState> {

  final VoiceRepository voiceRepository;
  VoiceBloc():
  voiceRepository = GetIt.instance<VoiceRepository>(),
      super(const VoiceState()) {
    on<VoiceEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ShowPlayer>(_onShowPlayer);
    on<FetchProfileVoice>(_onFetchProfileVoice);
    on<UpdateSimilarity>(_onUpdateSimilarity);
    on<UpdateStability>(_onUpdateStability);
    on<FetchAudioTest>(_onTestAudio);
    on<DeleteAudio>(_onDeletePath);
on<ShowRecordResponse>(_onShowRecordResponse);
on<ShowResponse>(_onShowAudioResponse);
on<ShowView>(_onShowView);
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
      print('event.isRecording');
      print(event.isRecording);

    } catch (e) {
      emit(state.copyWith(isRecording: false));
    }
  }
  void isRecording(bool isRecording) {
    add(ShowPlayer(isRecording));
  }


  Future<void> _onDeletePath(
      DeleteAudio event,
      Emitter<VoiceState> emit
      ) async {
    try {
      final List<String> paths = List.from(state.audioPaths);
      if (paths.isNotEmpty) {
        paths.removeLast();
        emit(state.copyWith(audioPaths: paths));
      }
    } catch (e) {
    }
  }
  void deleteAudio() {
    add(const DeleteAudio());
  }
  void collectAudio(String path) {
    add(CollectAudio(path));
  }


  Future<void> _onFetchProfileVoice(
      FetchProfileVoice event,
      Emitter<VoiceState> emit,
      ) async {
    try {
      int? userId = await SharedPreferencesManager.getUserId();
      final response = await voiceRepository.getProfileVoice(userId!);
      if (response == 'No clone') {
        emit(state.copyWith(
          isThereAudio: false,
        ));
      } else {
        final jsonResponse = jsonDecode(response);

        final int voiceId = jsonResponse['idVoice'];

        final String name = jsonResponse['name'];
        final String description = jsonResponse['description'];
        final String stability = jsonResponse['stability'] ?? 0;
        final String similarityBoost = jsonResponse['similarity_boost'] ?? 0;
        emit(
            state.copyWith(
            title: name,
            voiceId: voiceId.toString(),
            description: description,
            stability: stability,
            similarity: similarityBoost,
              isThereAudio: true,
            )
        );

      }
    } catch (e) {
      print('Error: $e');
    }
  }


  void fetchProfileVoice() {
    add(const FetchProfileVoice());
  }
  Future<void> _onUpdateStability(UpdateStability event, Emitter<VoiceState> emit,) async {
    emit(state.copyWith(
      stability: event.newStability.toString(),
    ));
  }

  void updateStability(double newValue) {
    add(UpdateStability(newValue));
  }

  Future<void> _onUpdateSimilarity(UpdateSimilarity event, Emitter<VoiceState> emit,) async {
    emit(state.copyWith(
      similarity: event.newSimilarity.toString(),
    ));
  }

  void updateSimilarity(double newValue) {
    add(UpdateSimilarity(newValue));
  }


  Future<void> _onTestAudio(FetchAudioTest event, Emitter<VoiceState> emit,) async {

    try{
      int? userId = await SharedPreferencesManager.getUserId();

      final response = await voiceRepository.testAudio(userId!, event.text);

      emit(state.copyWith(
        urlAudioTest: response,
      ));
    }catch(e){
      emit(state.copyWith(
        ));
    }


  }
  void testAudio(String text) {
    add(FetchAudioTest(text));
  }
  Future<void> _onShowRecordResponse(
      ShowRecordResponse event,
      Emitter<VoiceState> emit,
      ) async {
    try {
      if (event.isRecordingResponse) {
        emit(state.copyWith(isRecordingResponse: true));
      } else {
        emit(state.copyWith(isRecordingResponse: false));
      }

    } catch (e) {
      emit(state.copyWith(isRecordingResponse: false));
    }
  }
  Future<void> _onShowAudioResponse(
      ShowResponse event,
      Emitter<VoiceState> emit,
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
    add(ShowResponse(isThereAudio));
  }
  void recordResponse(bool isRecordingResponse){
    add(ShowRecordResponse(isRecordingResponse));
  }

  Future<void> _onShowView(
      ShowView event,
      Emitter<VoiceState> emit,
      ) async {
    try {
      if (event.isThereClone) {
        emit(state.copyWith(isThereClone: true));
      } else {
        emit(state.copyWith(isThereClone: false));
      }

    } catch (e) {
      print(e);
      //emit(state.copyWith(isRecording: false));
    }
  }
  void showView(bool isThereClone){
    add(ShowResponse(isThereClone));
  }
}

