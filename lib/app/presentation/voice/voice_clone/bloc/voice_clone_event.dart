part of 'voice_clone_bloc.dart';

abstract class VoiceCloneEvent extends Equatable {
  const VoiceCloneEvent();
}
class ShowAudioResponse extends VoiceCloneEvent {

  final bool isThereAudio;

  const ShowAudioResponse(this.isThereAudio);

  @override
  List<Object?> get props => [isThereAudio];

}

class ShowRecording extends VoiceCloneEvent {

  final bool isRecording;

  const ShowRecording(this.isRecording);

  @override
  List<Object?> get props => [isRecording];

}


class CollectAudio extends VoiceCloneEvent {
  final String path;

  const CollectAudio(this.path);

  @override
  // TODO: implement props
  List<Object?> get props => [path];

}
class DeleteAudio extends VoiceCloneEvent {
  const DeleteAudio();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}
class ClearPaths extends VoiceCloneEvent {
  const ClearPaths();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}

class BackAudio extends VoiceCloneEvent {
  const BackAudio();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}