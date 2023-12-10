import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:gdsc_app/classes/ClubCardData.dart';

const hostName = "10.0.2.2:3000";
class User{
  String uid ="";
  String displayName="";
  String downloadURL="";
  String email="";
  List<String> following=[];
  String role="";
  List<String> myEvents=[];
  List<ClubCardData> clubData = [];
  List<String> clubIds = [];
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
    this.following = List<String>.from(data['following'] ?? []);
    this.role = data['role'];
    this.myEvents = List<String>.from(data['myEvents'] ?? []);
    this.clubIds = List<String>.from(data['clubsOwned'] ?? []);


    return true;
  }


  Future<bool> getClubData() async {
    print("I am in get club data");

    if (this.clubIds != null) {
      print("Not null");

      for (var i = 0; i < this.clubIds.length; i++) {
        try {
          final clubIteration = await get(
            Uri.parse('http://localhost:3000/api/clubs/getClub/${this.clubIds[i]}'),
          );

          if (clubIteration.statusCode == 200) {
            var clubDataResponse = jsonDecode(clubIteration.body)['data'];

            clubData.add(
              ClubCardData(
                admin: clubDataResponse['admin'],
                category: clubDataResponse['category'],
                description: clubDataResponse['description'],
                downloadURL: clubDataResponse['downloadURL'],
                events: clubDataResponse['events'],
                followers: clubDataResponse['followers'],
                name: clubDataResponse['name'],
                type: clubDataResponse['type'],
                verified: clubDataResponse['verified'],
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

    print("Came out");
    return true;
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