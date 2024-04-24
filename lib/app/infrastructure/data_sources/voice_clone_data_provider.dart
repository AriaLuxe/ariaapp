import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../config/base_url_config.dart';
import '../../security/shared_preferences_manager.dart';

class VoiceCloneDataProvider {
  Future<void> cloneVoice(List<String> audioPaths) async {
    final url = '${BaseUrlConfig.baseUrl}/voice/add';
    String? token = await SharedPreferencesManager.getToken();
    int? userId = await SharedPreferencesManager.getUserId();
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['owner'] = '$userId';

    for (int i = 0; i < audioPaths.length; i++) {
      final audioPath = audioPaths[i];
      request.files.add(await http.MultipartFile.fromPath('audio', audioPath));
    }

    try {
      final response = await request.send();

      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        log('Solicitud exitosa: $responseString');
      } else {
        log('Error en la solicitud: $responseString');
      }
    } catch (e) {
      log('Error al enviar la solicitud: $e');
    }
  }

  Future<String> getProfileVoice(int userId) async {
    String? token = await SharedPreferencesManager.getToken();

    final response = await http.get(
      Uri.parse("${BaseUrlConfig.baseUrl}/voice/$userId"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return response.body;
    } else {
      return 'No clone';
    }
  }

  Future<String> editSettingsVoiceClone(
      int userId, double stability, double similarity) async {
    String? token = await SharedPreferencesManager.getToken();

    final response = await http.post(
      Uri.parse(
          "${BaseUrlConfig.baseUrl}/voice/settings/$userId?stability=$stability&similarity_boost=$similarity"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response.body;
  }

  Future<String> editVoiceClone(
      int userId, String name, String description) async {
    String? token = await SharedPreferencesManager.getToken();

    final body = {
      'name': name,
      'description': description,
    };

    final response = await http.post(
      Uri.parse("${BaseUrlConfig.baseUrl}/voice/edit/$userId"),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    return response.body;
  }

  Future<String> testAudio(int userId, String text) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      final response = await http.post(
        Uri.parse(
            "${BaseUrlConfig.baseUrl}/voice/text-to-speech/$userId?text=$text"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      return response.body;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteVoice(String voiceId) async {
    try {
      String? token = await SharedPreferencesManager.getToken();

      await http.delete(
        Uri.parse("${BaseUrlConfig.baseUrl}/voice/delete/$voiceId"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
