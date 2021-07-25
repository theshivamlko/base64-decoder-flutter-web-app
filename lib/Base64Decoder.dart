import 'dart:async';
import 'dart:html';
import 'dart:convert';

class Base64Decoder {
  static StreamController<String> resultStream = StreamController<String>();

  static Future<String?> decodeBase64ToText(String text) async {
    try {
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String result = stringToBase64.decode(text);
      resultStream.add('');
      return result;
    } catch (e) {
      print('$e');
      resultStream.addError("Error! Failed to convert");
      throw (e);
    }
  }
}
