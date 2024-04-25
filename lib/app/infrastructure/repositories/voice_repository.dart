import 'package:ariapp/app/domain/interfaces/voice_interface.dart';
import 'package:ariapp/app/infrastructure/data_sources/voice_clone_data_provider.dart';

class VoiceRepository extends VoiceInterface {
  final VoiceCloneDataProvider voiceCloneDataProvider;

  VoiceRepository({required this.voiceCloneDataProvider});

  @override
  Future<void> cloneVoice(List<String> audioPaths) async {
    return await voiceCloneDataProvider.cloneVoice(audioPaths);
  }

  @override
  Future<String> getProfileVoice(int userId) async {
    return await voiceCloneDataProvider.getProfileVoice(userId);
  }

  @override
  Future<String> editSettingsVoiceClone(
      int userId, double stability, double similarity) async {
    return await voiceCloneDataProvider.editSettingsVoiceClone(
        userId, stability, similarity);
  }

  @override
  Future<String> editVoiceClone(
      int userId, String name, String description) async {
    return await voiceCloneDataProvider.editVoiceClone(
        userId, name, description);
  }

  @override
  Future<String> testAudio(int userId, String text) async {
    return await voiceCloneDataProvider.testAudio(userId, text);
  }

  @override
  Future<void> deleteVoice(String voiceId) async {
    return await voiceCloneDataProvider.deleteVoice(voiceId);
  }
}
