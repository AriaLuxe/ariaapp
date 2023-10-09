part of 'voice_bloc.dart';

enum VoiceStatus {initial, loading, error, success}

 class VoiceState extends Equatable {
 final bool isRecording;
 final List<String> audioPaths;
 final VoiceStatus voiceStatus;
  const VoiceState({
   this.audioPaths = const <String>[],
  this.isRecording = false,
  this.voiceStatus = VoiceStatus.initial,
  });

  VoiceState copyWith({
  bool? isRecording,
   List<String>? audioPaths,
   VoiceStatus? voiceStatus,
 }){
   return VoiceState(
    isRecording: isRecording ?? this.isRecording,
    audioPaths: audioPaths ?? this.audioPaths,
    voiceStatus: voiceStatus ?? this.voiceStatus
   );
  }

  @override
  List<Object?> get props => [isRecording, audioPaths, voiceStatus];
}


