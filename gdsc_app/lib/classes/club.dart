import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import '../app_config.dart';
final serverUrl = AppConfig.serverUrl;

class Club{
  late bool verified;
  late String id;
  late String name;
  late String description;
  late String downloadURL;
  late String type;
  late String category;
  late Map<String, dynamic> followers;
  late List<dynamic> events;
  late List<dynamic> admin;
  Future<bool> addClub(clubName, clubBio, location, category, type, admin ) async {
    print("in SignIn");
    final response = await post(Uri.parse('$serverUrl/api/clubs/createClub'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "name": clubName,
        "description": clubBio,
        "downloadURL": "",
        "type": type,
        "category": category,
        "admin": admin,
      }),
    );
    if(response.statusCode == 200){
      return true;
    }
    else{
      return false;
    }

  }
  Future<bool> getClub(id) async {
    final response = await post(Uri.parse('$serverUrl/api/clubs/getClub'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "id": id,
      }),
    );
    var data = jsonDecode(response.body)['message'];
    this.id = data['uid'];
    this.name = data['name'];
    this.description = data['description'];
    this.downloadURL = data['downloadURL'];
    this.type = data['type'];
    this.category = data['category'];
    this.followers = data['followers'];
    this.events = data['events'];
    this.admin = data['admin'];
    if(response.statusCode == 200){
      return true;
    }
    else{
      return false;
    }
  }
}