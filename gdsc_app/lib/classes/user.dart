import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart' as p;

const hostName = "10.0.2.2:3000";

class User {
  String uid = "";
  String displayName = "";
  String downloadURL = "";
  String email = "";
  List<dynamic> following = [];
  String role = "";
  List<dynamic> myEvents = [];
  String gradYr = "update";

  Future<bool> isUserSignedIn() async {
    final response = await get(Uri.parse('http://$hostName/api/users/signedIn'));
    print(jsonDecode(response.body));
    if ((jsonDecode(response.body))['message'] == false) {
      return false;
    }
    return true;
  }

  Future<bool> initUserData() async {
    final response = await get(Uri.parse('http://$hostName/api/users/userData'));
    var data = jsonDecode(response.body)['message'];
    print(data['downloadURL'] is String);
    this.uid = data['uid'];
    this.displayName = data['displayName'];
    this.downloadURL = data['downloadURL'];
    this.email = data['email'];
    this.following = data['following'];
    this.role = data['role'];
    this.myEvents = data['myEvents'];
    return true;
  }

  Future<bool> signIn(String email, String password) async {
    print("in SignIn");
    final response = await post(
      Uri.parse('http://$hostName/api/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
  Future<bool> updateProfilePic(File img) async {
    dio.Dio dioClient = dio.Dio();
    String fileName = img.path.split('/').last;

    dio.FormData formData = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(
        img.path,
        filename: fileName,
      ),
      "uid": uid, // Make sure uid is set before calling this function
    });

    try {
      final response = await dioClient.post(
        "http://$hostName/api/users/updateProfileImage",
        data: formData,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error updating profile picture: $e');
      return false;
    }
  }



  String getMimetype(String fileName) {
    String extension = p.extension(fileName).toLowerCase();

    Map<String, String> mimeTypes = {
      ".jpg": "image/jpeg",
      ".jpeg": "image/jpeg",
      ".png": "image/png",
      ".gif": "image/gif",
      // Add more mappings as needed
    };

    return mimeTypes[extension] ?? "application/octet-stream";
  }
}
