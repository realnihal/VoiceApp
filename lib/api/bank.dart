import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:voice_app/api/tts.dart';

class RPBankAPI {
  void register({
    required String fullname,
    required String username,
    required String mobile,
    required String pin,
  }) async {
    var url = Uri.parse('http://events.respark.iitm.ac.in:5000/rp_bank_api');

    // to check balance
    var payload = json.encode({
      "action": "register",
      "nick_name": username,
      "full_name": fullname,
      "user_name": username,
      "pin_number": pin,
      "mob_number": mobile,
      "upi_id": "$username@rpbank"
    });

    var headers = {'Content-Type': 'application/json'};

    var response = await http.post(url, headers: headers, body: payload);
    print(response.body);
  }

  Future<bool> login({required String username, required String pin}) async {
    var url = Uri.parse('http://events.respark.iitm.ac.in:5000/rp_bank_api');

    // to check balance
    var payload = json.encode({
      "action": "details",
      "nick_name": username,
    });

    var headers = {'Content-Type': 'application/json'};

    var response = await http.post(url, headers: headers, body: payload);

    // check if pin is in response
    if (response.body.contains(pin)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> checkBalance({required String username}) async {
    var url = Uri.parse('http://events.respark.iitm.ac.in:5000/rp_bank_api');

    // to check balance
    var payload = json.encode({
      "action": "balance",
      "nick_name": username,
    });

    var headers = {'Content-Type': 'application/json'};

    var response = await http.post(url, headers: headers, body: payload);
    print(response.body);
    tts(text: "${response.body}rupees only");
  }

  Future<bool> transferMoney({
    required int amount,
    required String from,
    required String to,
  }) async {
    var url = Uri.parse('http://events.respark.iitm.ac.in:5000/rp_bank_api');

    // to check balance
    var payload = json.encode({
      "action": "transfer",
      "amount": amount,
      "from_user": from,
      "to_user": to
    });
    print(payload);

    var headers = {'Content-Type': 'application/json'};

    var response = await http.post(
      url,
      headers: headers,
      body: payload,
    );
    if (response.body.contains("success")) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> userDetails({required String user}) async {
    var url = Uri.parse('http://events.respark.iitm.ac.in:5000/rp_bank_api');

    // to check balance
    var payload = json.encode({
      "action": "details",
      "nick_name": user,
    });

    var headers = {'Content-Type': 'application/json'};

    var response = await http.post(url, headers: headers, body: payload);
    var responseBody = response.body;

    print(responseBody);
  }

  Future<void> userRemove({required String user}) async {
    var url = Uri.parse('http://events.respark.iitm.ac.in:5000/rp_bank_api');

    // to check balance
    var payload = json.encode({
      "action": "remove",
      "nick_name": user,
    });

    var headers = {'Content-Type': 'application/json'};

    var response = await http.post(url, headers: headers, body: payload);
    var responseBody = response.body;

    var text = json.decode(responseBody);
    print(text);
  }

  Future<String> userHistory({required String user}) async {
    var url = Uri.parse('http://events.respark.iitm.ac.in:5000/rp_bank_api');

    // to check balance
    var payload = json.encode({
      "action": "history",
      "nick_name": user,
    });

    var headers = {'Content-Type': 'application/json'};

    var response = await http.post(url, headers: headers, body: payload);
    var responseBody = response.body;

    print(responseBody);
    return responseBody;
  }
}
