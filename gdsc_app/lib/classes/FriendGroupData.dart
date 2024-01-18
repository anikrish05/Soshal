import 'package:gdsc_app/classes/userData.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import '../app_config.dart';
import '../utils.dart';

final serverUrl = AppConfig.serverUrl;

class FriendGroup {
  List<String> friendCircle;
  String name;

  FriendGroup({
    required this.friendCircle,
    required this.name,
  });

}
