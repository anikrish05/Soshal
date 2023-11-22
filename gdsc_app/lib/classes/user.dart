import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

class User{
  int? uid;
  String? displayName;
  String? downloadURL;
  String? email;
  List<int>? following;
  String? role;
  List<int>? myEvents;

  Future<bool> isUserSignedIn() async {
    final response = await get(Uri.parse('http://10.0.2.2:3000/signedIn'));
    print(jsonDecode(response.body));
    if ((jsonDecode(response.body))['message'] == false) {
      return false;
    }
    return true;
  }

  void initUserData() async{
    final response = await get(Uri.parse('http://10.0.2.2:3000/userData'));
    var data = jsonDecode(response.body);
    this.uid = data.uid;
    this.displayName = data.displayName;
    this.downloadURL = data.downloadURL;
    this.email = data.email;
    this.following = data.following;
    this.role = data.role;
    this.myEvents = data.myEvents;
  }

}