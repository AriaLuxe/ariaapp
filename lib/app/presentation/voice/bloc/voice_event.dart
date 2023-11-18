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
class DeleteAudio extends VoiceEvent {
  const DeleteAudio();

}
class CloneVoice extends VoiceEvent {
  final String photoPath;
  final int ownerId;
  final List<String> audioPaths;
  final String title;
  final String description;

  const CloneVoice(this.photoPath, this.ownerId, this.audioPaths, this.title, this.description,);
}
class ShowPlayer extends VoiceEvent {

  final bool isRecording;

  const ShowPlayer(this.isRecording);

}
class FetchProfileVoice extends VoiceEvent {
  const FetchProfileVoice();

}

class UpdateStability extends VoiceEvent {
  final double newStability;

  const UpdateStability(this.newStability);

  @override
  List<Object?> get props => [newStability];
}

class UpdateSimilarity extends VoiceEvent {
  final double newSimilarity;

  const UpdateSimilarity(this.newSimilarity);

  @override
  List<Object?> get props => [newSimilarity];
}
class FetchAudioTest extends VoiceEvent {
  final String text;

  const FetchAudioTest(this.text);

  @override
  List<Object?> get props => [text];
}

class ShowResponse extends VoiceEvent {

  final bool isThereAudio;

  const ShowResponse(this.isThereAudio);

}

class ShowRecordResponse extends VoiceEvent {

  final bool isRecordingResponse;

  const ShowRecordResponse(this.isRecordingResponse);

}

class ShowView extends VoiceEvent {

  final bool isThereClone;

  const ShowView(this.isThereClone);

}