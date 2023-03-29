import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

void tts({required String text}) async {
  AudioPlayer player = AudioPlayer();
  const gender = 'male';
  const lang = 'English';

  final url = Uri.parse('https://asr.iitm.ac.in/ttsv2/tts');
  final payload = jsonEncode(<String, dynamic>{
    'input': text,
    'gender': gender,
    'lang': lang,
    'alpha': 1,
    // 'segmentwise': true,
  });

  final headers = {'Content-Type': 'application/json'};
  final response = await http.post(url, headers: headers, body: payload);

  final audio = jsonDecode(response.body)['audio'];
  Uint8List decoded = base64.decode(audio);
  print(decoded);

  // await audioPlayer.play(BytesSource(decoded));
  // Comment this out to listen to tts.wav
  await player.play(BytesSource(decoded));

  print('done');
}
