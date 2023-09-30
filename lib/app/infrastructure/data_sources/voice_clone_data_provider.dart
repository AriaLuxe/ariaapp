import 'dart:io';

import 'package:http/http.dart' as http;

class VoiceCloneDataProvider {
  Future<void> cloneVoice(File audio, File file) async {
    try {
      final uri =
          Uri.parse('https://ariachat-production.up.railway.app/voice/add');
      final request = http.MultipartRequest('POST', uri);

      // Agrega el archivo de audio a la solicitud
      request.files.add(
        http.MultipartFile(
          'audio',
          audio.readAsBytes().asStream(),
          audio.lengthSync(),
          filename: 'audio.mp3',
        ),
      );

      // Agrega el archivo de imagen a la solicitud
      request.files.add(
        http.MultipartFile(
          'file',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: 'image.jpg',
        ),
      );

      request.fields['owner'] = '1';
      request.fields['name'] = 'sadasd';
      request.fields['description'] = 'asd asd asd sad';

      final response = await http.Response.fromStream(await request.send());

      print('clonado');
      print(response.body);
    } catch (e) {
      print(e);
    }
  }
}
