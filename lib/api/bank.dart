import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:voice_app/api/encryption.dart';
import 'package:voice_app/api/tts.dart';

class User {
  String id;
  String nickName;
  String fullName;
  String userName;
  String pinNumber;
  String mobNumber;
  String upiId;

  User({
    required this.id,
    required this.nickName,
    required this.fullName,
    required this.userName,
    required this.pinNumber,
    required this.mobNumber,
    required this.upiId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      nickName: json['nick_name'],
      fullName: json['full_name'],
      userName: json['user_name'],
      pinNumber: json['pin_number'],
      mobNumber: json['mob_number'],
      upiId: json['upi_id'],
    );
  }
}

class RPBankAPI {
  final token = "rp-1zlhyiu6gkwi2oa";

  Future<bool> register({
    required String fullname,
    required String username,
    required String mobile,
    required String pin,
  }) async {
    var url = Uri.parse('https://events.respark.iitm.ac.in:3000/rp_bank_api');

    // to check balance
    var payload = json.encode({
      "action": "register",
      "nick_name": username,
      "api_token": token,
      "full_name": fullname,
      "user_name": username,
      "pin_number": pin,
      "mob_number": mobile,
      "upi_id": "$username@rpbank"
    });

    var headers = {'Content-Type': 'application/json'};

    BankEncryption bankEncryption = BankEncryption();
    final encrypteddata = await bankEncryption.encrypt(payload);

    print(encrypteddata);

    var response = await http.post(url, headers: headers, body: encrypteddata);
    print(response.body);
    final output = await bankEncryption.decrypt(response.body.split("'")[1]);
    print(output);
    if (output.contains("success")) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> login({required String username, required String pin}) async {
    var url = Uri.parse('https://events.respark.iitm.ac.in:3000/rp_bank_api');

    // to check balance
    var payload = json.encode({
      "action": "details",
      "api_token": token,
      "nick_name": username,
    });

    var headers = {'Content-Type': 'application/json'};

    BankEncryption bankEncryption = BankEncryption();
    final encrypteddata = await bankEncryption.encrypt(payload);

    print(encrypteddata);

    var response = await http.post(url, headers: headers, body: encrypteddata);
    print(response.body);
    final output = await bankEncryption.decrypt(response.body.split("'")[1]);
    print(output);

    // check if pin is in response
    if (output.contains(pin)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> checkBalance({required String username}) async {
    var url = Uri.parse('https://events.respark.iitm.ac.in:3000/rp_bank_api');

    // to check balance
    var payload = json.encode({
      "action": "balance",
      "api_token": token,
      "nick_name": username,
    });

    BankEncryption bankEncryption = BankEncryption();
    final encrypteddata = await bankEncryption.encrypt(payload);
    var headers = {'Content-Type': 'application/json'};
    try {
      var response =
          await http.post(url, headers: headers, body: encrypteddata);
      print(response.body);
      final output = await bankEncryption.decrypt(response.body.split("'")[1]);
      print(output);
      tts(text: "${output}rupees only");
    } on SocketException catch (err) {
      print(err);
    }
  }

  Future<bool> transferMoney({
    required int amount,
    required String from,
    required String to,
  }) async {
    var url = Uri.parse('https://events.respark.iitm.ac.in:3000/rp_bank_api');

    // to check balance
    var payload = json.encode({
      "action": "transfer",
      "amount": amount,
      "api_token": token,
      "from_user": from,
      "to_user": to
    });
    print(payload);

    var headers = {'Content-Type': 'application/json'};

    BankEncryption bankEncryption = BankEncryption();
    final encrypteddata = await bankEncryption.encrypt(payload);

    print(encrypteddata);

    var response = await http.post(url, headers: headers, body: encrypteddata);
    print(response.body);
    final output = await bankEncryption.decrypt(response.body.split("'")[1]);
    print(output);
    if (output.contains("success")) {
      return true;
    } else {
      return false;
    }
  }

  Future<User> userDetails({required String user}) async {
    print(user);
    JsonCodec codec = const JsonCodec();
    var url = Uri.parse('https://events.respark.iitm.ac.in:3000/rp_bank_api');

    // to check balance
    var payload = json.encode({
      "action": "details",
      "api_token": token,
      "nick_name": user,
    });

    var headers = {'Content-Type': 'application/json'};
    BankEncryption bankEncryption = BankEncryption();
    final encrypteddata = await bankEncryption.encrypt(payload);

    print(encrypteddata);

    var response = await http.post(url, headers: headers, body: encrypteddata);
    print("OUTPUT");
    print(response.body);
    var output = await bankEncryption.decrypt(response.body.split("'")[1]);
    print("OUTPUT");
    print(output);

    // // Manually decode the response
    output = output.replaceAll("'", "\"");
    String userId = output.substring(18, 42);
    output = "{\"_id\": \"$userId\", ${output.substring(46)}";
    print(output);
    User userNew = User.fromJson(jsonDecode(output));
    print(userNew.fullName);
    return userNew;
  }

  Future<void> userRemove({required String user}) async {
    var url = Uri.parse('https://events.respark.iitm.ac.in:3000/rp_bank_api');

    // to check balance
    var payload = json.encode({
      "action": "remove",
      "nick_name": user,
      "api_token": token,
    });

    var headers = {'Content-Type': 'application/json'};

    BankEncryption bankEncryption = BankEncryption();
    final encrypteddata = await bankEncryption.encrypt(payload);

    print(encrypteddata);

    var response = await http.post(url,
        headers: headers,
        body: encrypteddata,
        encoding: Encoding.getByName("utf-8"));
    print(response.body);
    var output = await bankEncryption.decrypt(response.body.split("'")[1]);
    print(output);

    if (output.contains("")) {
      tts(text: "User removed successfully");
    } else {
      tts(text: "User not found");
    }
  }

  Future<List> userHistory({required String user}) async {
    var url = Uri.parse('https://events.respark.iitm.ac.in:3000/rp_bank_api');

    // to check balance
    var payload = json.encode({
      "action": "history",
      "nick_name": user,
      "api_token": token,
    });

    var headers = {'Content-Type': 'application/json'};

    BankEncryption bankEncryption = BankEncryption();
    final encrypteddata = await bankEncryption.encrypt(payload);

    print(encrypteddata);

    var response = await http.post(url,
        headers: headers,
        body: encrypteddata,
        encoding: Encoding.getByName("utf-8"));
    print(response.body);
    var output = await bankEncryption.decrypt(response.body.split("'")[1]);
    print(output);
    output = output.replaceAll("'", '"');
    output = output.replaceAll("ObjectId(", "");
    output = output.replaceAll(")", "");

    List jsonparsed = json.decode(output);

    print(output);
    if (jsonparsed.length < 10) {
    } else {
      jsonparsed = jsonparsed.reversed.toList().sublist(0, 10);
    }
    return jsonparsed;
  }
}
