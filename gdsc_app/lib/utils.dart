import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app_config.dart';
final serverUrl = AppConfig.serverUrl;

Future<Map<String, String>> getHeaders() async {
  final storage = FlutterSecureStorage();
  String? accessToken = await storage.read(key: 'access_token');

  if (accessToken != null) {
          return {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': accessToken!,
          };
        }
  // No valid access token found, handle this case accordingly
  print("No valid access token found");
  return {};
}
