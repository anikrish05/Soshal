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
    final DateTime expiryTime = DateTime.fromMillisecondsSinceEpoch(
      int.parse(await storage.read(key: 'access_token_expiry') ?? '0'),
    );

    // Check if the access token is still valid
    if (DateTime.now().isBefore(expiryTime)) {
      print("Access token is still valid");
      return {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken,
      };
    } else {
      // Access token has expired, call the login API to refresh tokens
      print("Access token has expired, refreshing...");

      try {
        final http.Response response = await http.post(
          Uri.parse('$serverUrl/api/users/login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "email": await storage.read(key: 'email') ?? '',
            "password": await storage.read(key: 'password') ?? '',
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);

          // Update the access token and expiry time
          accessToken = responseData['user']['stsTokenManager']['accessToken'];
          final DateTime newExpiryTime = DateTime.now().add(Duration(seconds: responseData['user']['stsTokenManager']['expiresIn']));

          await storage.write(key: 'access_token', value: accessToken);
          await storage.write(key: 'access_token_expiry', value: newExpiryTime.millisecondsSinceEpoch.toString());

          print("Access token refreshed successfully");
          return {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': accessToken!,
          };
        } else {
          // Handle login API error
          print("Error refreshing access token: ${response.statusCode}");
          return {};
        }
      } catch (error) {
        print("Error refreshing access token: $error");
        // Handle other errors
        return {};
      }
    }
  }

  // No valid access token found, handle this case accordingly
  print("No valid access token found");
  return {};
}
