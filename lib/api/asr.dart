import "dart:convert";

import "package:http/http.dart" as http;

Future<String> asr({required String path}) async {
  try {
    var inputLanguage = 'english'; // input audio language
    var inputAudioPath = path; // input audio path
    var url = Uri.parse('https://asr.iitm.ac.in/asr/v2/decode'); // endpoint

    // Extracting the audio file name
    var audioFile = inputAudioPath.split('/').reversed.first;

    // JSON payload
    var payload = {'vtt': 'true', 'language': inputLanguage};

    // Audio file in binary format
    var request = http.MultipartRequest('POST', url)
      ..headers['content-type'] = 'multipart/form-data'
      ..fields.addAll(payload)
      ..files.add(await http.MultipartFile.fromPath('file', inputAudioPath));
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    // Get the transcript only
    var text = json.decode(responseBody);
    String stt = text['transcript'];

    print(responseBody); // Complete response\\
    print(stt);
    return stt;
  } on Exception {
    return "Try again";
  }
// Transcript only
}
