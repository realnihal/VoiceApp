import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/asymmetric/api.dart';

class BankEncryption {
  Future<String> encrypt(String data) async {
    final publicPem = await rootBundle.loadString('assets/keys/public_key.pem');
    final publicKey = RSAKeyParser().parse(publicPem) as RSAPublicKey;

    final privatePem =
        await rootBundle.loadString('assets/keys/private_key.pem');
    final privateKey = RSAKeyParser().parse(privatePem) as RSAPrivateKey;

    final encrypter =
        Encrypter(RSA(publicKey: publicKey, privateKey: privateKey));

    final encrypted = encrypter.encrypt(data);

    return encrypted.base64.toString();
  }

  Future<String> decrypt(String encryptedData) async {
    final publicPem = await rootBundle.loadString('assets/keys/public_key.pem');
    final publicKey = RSAKeyParser().parse(publicPem) as RSAPublicKey;

    final privatePem =
        await rootBundle.loadString('assets/keys/private_key.pem');
    final privateKey = RSAKeyParser().parse(privatePem) as RSAPrivateKey;

    final encrypter =
        Encrypter(RSA(publicKey: publicKey, privateKey: privateKey));

    final decrypted = encrypter.decrypt(Encrypted.fromBase64(encryptedData));

    return decrypted.toString();
  }
}
