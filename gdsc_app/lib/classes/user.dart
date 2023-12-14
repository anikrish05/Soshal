// classes/User.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart' as p;
import 'package:gdsc_app/classes/ClubCardData.dart';

const hostName = "10.0.2.2:3000";

class User {
  String uid = "";
  String displayName = "";
  String downloadURL = "";
  String email = "";
  List<String> following = [];
  String role = "";
  List<String> myEvents = [];
  List<ClubCardData> clubData = [];
  List<String> clubIds = [];
  String gradYr = "update";

  Future<bool> isUserSignedIn() async {
    try {
      final response = await get(Uri.parse('http://$hostName/api/users/signedIn'));
      print(jsonDecode(response.body));
      return (jsonDecode(response.body))['message'] == true;
    } catch (error) {
      print('Error checking if user is signed in: $error');
      return false;
    }
  }

  Future<bool> initUserData() async {
    try {
      final response = await get(Uri.parse('http://$hostName/api/users/userData'));
      var data = jsonDecode(response.body)['message'];
      this.uid = data['uid'];
      this.displayName = data['displayName'];
      this.downloadURL = data['downloadURL'];
      this.email = data['email'];
      this.following = List<String>.from(data['following'] ?? []);
      this.role = data['role'];
      this.myEvents = List<String>.from(data['myEvents'] ?? []);
      this.clubIds = List<String>.from(data['clubsOwned'] ?? []);

      return true;
    } catch (error) {
      print('Error initializing user data: $error');
      return false;
    }
  }

  Future<bool> getClubData() async {
    if (this.clubIds != null) {
      for (var i = 0; i < this.clubIds.length; i++) {
        print("loop" + i.toString());
        try {
          final clubIteration = await get(
            Uri.parse('http://$hostName/api/clubs/getClub/${this.clubIds[i]}'),
          );

          if (clubIteration.statusCode == 200) {
            var clubDataResponse = jsonDecode(clubIteration.body)['message'];
            clubData.add(
              ClubCardData(
                admin: List<String>.from((clubDataResponse['admin'] ?? []).map((event) => event.toString())),
                category: clubDataResponse['category'],
                description: clubDataResponse['description'],
                downloadURL: clubDataResponse['downloadURL'],
                events: List<String>.from((clubDataResponse['events'] ?? []).map((event) => event.toString())),
                followers: List<String>.from((clubDataResponse['followers'] ?? []).map((follower) => follower.toString())),
                name: clubDataResponse['name'],
                type: clubDataResponse['type'],
                verified: clubDataResponse['verified'],
                id: this.clubIds[i]
              ),
            );

            print("Club data added for ID ${this.clubIds[i]}");
          } else {
            print("Error fetching club data for ID ${this.clubIds[i]} - StatusCode: ${clubIteration.statusCode}");
          }
        } catch (error) {
          print("Error fetching club data for ID ${this.clubIds[i]}: $error");
        }
      }
    } else {
      print("clubIds is null");
    }
    return true;
  }

  Future<bool> signIn(String email, String password) async {
    print("in SignIn");
    try {
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
      return response.statusCode == 200;
    } catch (error) {
      print('Error signing in: $error');
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

      return response.statusCode == 200;
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
