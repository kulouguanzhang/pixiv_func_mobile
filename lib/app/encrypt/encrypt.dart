/*
 * Copyright (C) 2022. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:encrypt.dart
 * 创建时间:2022/4/8 下午6:00
 * 作者:小草
 */
import 'package:encrypt/encrypt.dart' as encrypt;

class Encrypt {
  Encrypt._();

  static const keyString = 'xiaocao-pixiv-func-key-aes-len32';
  static final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(keyString), mode: encrypt.AESMode.ecb));

  static final iv = encrypt.IV.fromLength(16);

  static String encode(String input) {
    return encrypter.encrypt(input, iv: iv).base64;
  }

  static String decode(String input) {
    return encrypter.decrypt64(input, iv: iv);
  }
}
