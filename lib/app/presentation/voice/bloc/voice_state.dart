part of 'voice_bloc.dart';


 class VoiceState extends Equatable {

  const VoiceState(  {
   this.audioPaths = const <String>[],
  this.isRecording = false,
   this.voiceId = '',
   this.title = '',
   this.description = '',
   this.similarity = '',
   this.stability = '',
   this.urlAudioTest = '',
   this.isRecordingResponse = false,
   this.isThereAudio = false,
   this.isThereClone  = false,
  });
  final bool isRecording;
  final List<String> audioPaths;
  final String voiceId;
  final String title;
  final String description;
  final String stability;
  final String similarity;
  final String urlAudioTest;

  final bool isRecordingResponse;
  final bool isThereAudio;
  final bool isThereClone;

  VoiceState copyWith({
  bool? isRecording,
   List<String>? audioPaths,
   String? title,
    String? description,
   String? stability,
   String? similarity,
   String? urlAudioTest,

   bool? isRecordingResponse,
   bool? isThereAudio,  String? voiceId,   bool? isThereClone,

  }){
   return VoiceState(
    isRecording: isRecording ?? this.isRecording,
    audioPaths: audioPaths ?? this.audioPaths,
    voiceId: voiceId ?? this.voiceId,
    title: title ?? this.title,
    description: description ?? this.description,
    stability: stability ?? this.stability,
    similarity: similarity ?? this.similarity,
    urlAudioTest: urlAudioTest ?? this.urlAudioTest,
    isThereClone: isThereClone ?? this.isThereClone,
    isRecordingResponse: isRecordingResponse ?? this.isRecordingResponse,
    isThereAudio: isThereAudio ?? this.isThereAudio,
   );
  }

  @override
  List<Object?> get props => [isRecording, audioPaths,title,voiceId,description,similarity,stability,isThereClone,urlAudioTest,isRecordingResponse,isThereAudio];
}


