// lib/app_config.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String? _serverUrl = '';

  static String? get serverUrl => _serverUrl;

  static Future<void> loadEnvironment() async {
    await dotenv.load();
    if(dotenv.env['IS_PRODUCTION'] == 'true'){
      _serverUrl =  dotenv.env['PRODUCTION_SERVER_URL'];
    }
    else if(dotenv.env['TYPE'] == "Android"){
      _serverUrl =  dotenv.env['LOCAL_ANDROID_SERVER_URL'];
    }
    else if(dotenv.env['TYPE'] == "IOS"){
      _serverUrl =  dotenv.env['LOCAL_IOS_SERVER_URL'];
    }
  }
}
