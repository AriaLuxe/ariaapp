part of 'voice_clone_bloc.dart';

 class VoiceCloneState extends Equatable {
  const VoiceCloneState({
    this.audioPaths = const <String>[],
    this.isRecording = false,
    this.isThereAudio = false,
   // this.responses = const [],
  });

  final bool isRecording;
  final bool isThereAudio;
  final List<String> audioPaths;
  //final List<Response> responses;

  VoiceCloneState copyWith({
    List<String>? audioPaths,
    bool? isRecording,
    bool? isThereAudio,
   // List<Response>? responses,
  }){
    return VoiceCloneState(
      audioPaths: audioPaths ?? this.audioPaths,
      isRecording: isRecording ?? this.isRecording,
      isThereAudio: isThereAudio ?? this.isThereAudio,
      //responses: responses ?? this.responses,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [audioPaths, isRecording, isThereAudio,
    //responses
  ];

}


