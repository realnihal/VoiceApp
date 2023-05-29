import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

Future<void> tts({required String text}) async {
  final prefs = await SharedPreferences.getInstance();
  final lan = prefs.getString('language') ?? "english";
  AudioPlayer player = AudioPlayer();
  const gender = 'female';

  if (lan == "telugu") {
    final translator = GoogleTranslator();
    var translate = await translator.translate(text, to: 'te');
    text = translate.text;
    print(text);
  }

  final url = Uri.parse('https://asr.iitm.ac.in/ttsv2/tts');
  final payload = jsonEncode(<String, dynamic>{
    'input': text,
    'gender': gender,
    'lang': lan,
    'alpha': 1,
    // 'segmentwise': true,
  });

  final headers = {'Content-Type': 'application/json'};
  final response = await http.post(url, headers: headers, body: payload);

  final audio = jsonDecode(response.body)['audio'];
  Uint8List decoded = base64.decode(audio);

  // await audioPlayer.play(BytesSource(decoded));
  // Comment this out to listen to tts.wav
  await player.play(BytesSource(decoded));
}
