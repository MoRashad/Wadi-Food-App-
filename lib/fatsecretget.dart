import 'dart:convert';

import 'package:crypto/crypto.dart';

class Fatsecretget{
  final identifier = '712d445f5b5b422bae27ae637219595f';
  final secret = 'ad65122fcb004352a6d551b0e7766c15';
  final app_method = 'GET';
  final request_url = 'http://platform.fatsecret.com/rest/server.api';
  final signmethod = 'HMAC-SHA1';
  final oauthversion = '2.0';

  var sighasher;
  Fatsecretget(){
    var bytes = utf8.encode('$secret&');
    sighasher = new Hmac(sha1, bytes);
  }
  fetchallfoodsfroomapi() async{
    Map<String, String> params = {
      'oauth_consumer_key': identifier,
      'oauth_signature_method': signmethod,
      'oauth_timestamp': (DateTime.now().millisecondsSinceEpoch).toString(),
      'oauth_version': (1.0).toString(),
      'format': 'json',
      'method': 'foods.search',
      'search_expression': 'cheese',
    };
  }
  
}