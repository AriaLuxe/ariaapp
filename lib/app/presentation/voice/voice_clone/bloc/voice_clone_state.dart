part of 'voice_clone_bloc.dart';

class VoiceCloneState extends Equatable {
  const VoiceCloneState({
    this.audioPaths = const <String>[],
    this.isRecording = false,
    this.isThereAudio = false,
  });

  final bool isRecording;
  final bool isThereAudio;
  final List<String> audioPaths;

  VoiceCloneState copyWith({
    List<String>? audioPaths,
    bool? isRecording,
    bool? isThereAudio,
  }) {
    return VoiceCloneState(
      audioPaths: audioPaths ?? this.audioPaths,
      isRecording: isRecording ?? this.isRecording,
      isThereAudio: isThereAudio ?? this.isThereAudio,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        audioPaths,
        isRecording,
        isThereAudio,
      ];
}
