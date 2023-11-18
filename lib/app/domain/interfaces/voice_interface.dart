abstract class VoiceInterface {
  Future<String> getProfileVoice(int userId);

  Future<void> cloneVoice(List<String> audioPaths, String imgPath, String name,
      String description);

  Future<String> editSettingsVoiceClone(int userId,double stability, double similarity);
  Future<String> editVoiceClone(int userId, String name, String description);
  Future<String> testAudio(int userId, String text);

  }