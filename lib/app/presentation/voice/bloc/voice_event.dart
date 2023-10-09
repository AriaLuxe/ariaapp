part of 'voice_bloc.dart';

abstract class VoiceEvent extends Equatable {
  const VoiceEvent();

  @override
  List<Object?> get props => [];
}
class CollectAudio extends VoiceEvent {
  final String path;

  const CollectAudio(this.path);

}
class CloneVoice extends VoiceEvent {
  final String photoPath;
  final int ownerId;
  final List<String> audioPaths;
  final String name;
  final String description;

  const CloneVoice(this.photoPath, this.ownerId, this.audioPaths, this.name, this.description,);
}
class ShowPlayer extends VoiceEvent {

  final bool isRecording;

  const ShowPlayer(this.isRecording);

}