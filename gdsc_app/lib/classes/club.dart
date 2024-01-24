import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import '../app_config.dart';
import '../utils.dart';
final serverUrl = AppConfig.serverUrl;

class Club{
  late bool? verified;
  late String? id;
  late String? name;
  late String? description;
  late String? downloadURL;
  late String? type;
  late Map<String, dynamic>? followers;
  late List<dynamic>? events;
  late List<dynamic>? admin;
  late double? avgRating;
  late List<dynamic>? tags;
  Future<bool> addClub(clubName, clubBio, location, type, admin, tags ) async {
    print("in SignIn");
    final response = await post(Uri.parse('$serverUrl/api/clubs/createClub'),
        headers: await getHeaders(),
        body: jsonEncode(<String, dynamic>{
        "name": clubName,
        "description": clubBio,
        "type": type,
        "admin": admin,
        "tags": tags
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
      headers: await getHeaders(),
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
    this.followers = data['followers'];
    this.events = data['events'];
    this.admin = data['admin'];
    this.avgRating = data['avgRating'];
    this.tags = data['tags'];
    if(response.statusCode == 200){
      return true;
    }
    else{
      return false;
    }
  }
}