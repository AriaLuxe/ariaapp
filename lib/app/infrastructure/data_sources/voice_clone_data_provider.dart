import 'dart:io';

import 'package:http/http.dart' as http;

class VoiceCloneDataProvider {


  Future<void> cloneVoice(List<String> audioPaths, String imgPath, String name, String description) async {
    const url = 'https://ariachat-production.up.railway.app/voice/add';

    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(await http.MultipartFile.fromPath('image', imgPath));

    request.fields['name'] = name;
    request.fields['description'] = description;

    for (int i = 0; i < audioPaths.length; i++) {
      final audioPath = audioPaths[i];
      request.files.add(await http.MultipartFile.fromPath('audio', audioPath));
    }

    try {
      final response = await request.send();

      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('Solicitud exitosa: $responseString');
      } else {
        print('Error en la solicitud: $responseString');
      }
    } catch (e) {
      print('Error al enviar la solicitud: $e');
    }
  }

}
