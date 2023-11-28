import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
const hostName = "10.0.2.2:3000";
class User{
  int? uid;
  String? displayName;
  String? downloadURL;
  String? email;
  List<int>? following;
  String? role;
  List<int>? myEvents;
  Future<bool> isUserSignedIn() async {
    final response = await get(Uri.parse('http://$hostName/api/users/signedIn'));
    print(jsonDecode(response.body));
    if ((jsonDecode(response.body))['message'] == false) {
      return false;
    }
    return true;
  }

  void initUserData() async{
    final response = await get(Uri.parse('http://$hostName/api/users/userData'));
    var data = jsonDecode(response.body);
    this.uid = data.uid;
    this.displayName = data.displayName;
    this.downloadURL = data.downloadURL;
    this.email = data.email;
    this.following = data.following;
    this.role = data.role;
    this.myEvents = data.myEvents;
  }

  Future<bool> signIn(String email, String password) async{
    print("in SignIn");
    final response = await post(Uri.parse('http://$hostName/api/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password
      }),
    );
    if(response.statusCode == 200){
      return true;
    }
    else{
      return false;
    }

  }

}