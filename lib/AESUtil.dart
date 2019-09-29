import 'dart:convert';
import "dart:typed_data";

import 'package:pointycastle/pointycastle.dart';

class AESUtil {
  ///Base64加密+AES+Base64加密
  static encrypt2Base64(String keyStr, String data) {
    data = Base64Encoder().convert(utf8.encode(data));
    Uint8List encrypted = encrypt(keyStr, data);
    String content = Base64Encoder().convert(encrypted);
    return content;
  }

  ///Base64解密+AES+Base64解密
  static decrypt2Base64(String keyStr, String data) {
    String newData = data.replaceAll(RegExp("\n"), "");
    Uint8List decrypted = Base64Decoder().convert(newData);
    String content = decrypt(keyStr, decrypted);
    content = utf8.decode(Base64Decoder().convert(content)); 
    var res = json.decode(content);
    return res;
  }

  ///AES加密
  static encrypt(String keyStr, String data) {
    final key = Uint8List.fromList(keyStr.codeUnits);
//  设置加密偏移量IV
//  var iv = Digest("SHA-256").process(utf8.encode(message)).sublist(0, 16);
//  CipherParameters params = PaddedBlockCipherParameters(
//      ParametersWithIV(KeyParameter(key), iv), null);
    CipherParameters params =
        PaddedBlockCipherParameters(KeyParameter(key), null);
    BlockCipher encryptionCipher = PaddedBlockCipher("AES/ECB/PKCS7");
    encryptionCipher.init(true, params);
    Uint8List encrypted = encryptionCipher.process(utf8.encode(data));
    return encrypted;
  }

  ///AES解密
  static decrypt(String keyStr, Uint8List data) {
    final key = Uint8List.fromList(keyStr.codeUnits);
    CipherParameters params =
        PaddedBlockCipherParameters(KeyParameter(key), null);
    BlockCipher decryptionCipher = PaddedBlockCipher("AES/ECB/PKCS7");
    decryptionCipher.init(false, params);
    String decrypted = utf8.decode(decryptionCipher.process(data));
    return decrypted;
  }
}
