import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<Map<String, String>> getHeaders() async {
  final storage = FlutterSecureStorage();
  String? accessToken = await storage.read(key: 'access_token');
  print("IN UTILOTY");
  print(accessToken);
  return {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': accessToken!
  };
}
