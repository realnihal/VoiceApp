import 'dart:convert';

import 'package:http/http.dart' as http;

void test() async {
  const gender = 'male';
  const lang = 'Hindi';
  const text = 'चॉकलेट आइसक्रीम बनाने की विधि बताओ';

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
  print(audio);

  print('done');
}
