import 'dart:convert';

import 'package:cryptography/cryptography.dart';

class EncryptionService {
  EncryptionService({required this.algorithm});

  final Cipher algorithm;

  Future<String> encrypt({
    required String plaintext,
    required SecretKey secretKey,
  }) async {
    final nonce = algorithm.newNonce();
    final secretBox = await algorithm.encrypt(
      utf8.encode(plaintext),
      secretKey: secretKey,
      nonce: nonce,
    );

    final payload = <String, dynamic>{
      'nonce': base64Encode(secretBox.nonce),
      'cipherText': base64Encode(secretBox.cipherText),
      'mac': base64Encode(secretBox.mac.bytes),
    };

    return jsonEncode(payload);
  }

  Future<String> decrypt({
    required String payload,
    required SecretKey secretKey,
  }) async {
    final json = jsonDecode(payload) as Map<String, dynamic>;
    final nonce = base64Decode(json['nonce'] as String);
    final cipherText = base64Decode(json['cipherText'] as String);
    final macBytes = base64Decode(json['mac'] as String);

    final clearText = await algorithm.decrypt(
      SecretBox(cipherText, nonce: nonce, mac: Mac(macBytes)),
      secretKey: secretKey,
    );

    return utf8.decode(clearText);
  }

  Future<SecretKey> generateSecretKey() {
    return algorithm.newSecretKey();
  }

  List<int> generateNonce() {
    return algorithm.newNonce();
  }

  Future<void> warmUp() async {
    await generateSecretKey();
  }
}
