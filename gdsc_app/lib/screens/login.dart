import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:gdsc_app/classes/user.dart';
import '../app_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


final serverUrl = AppConfig.serverUrl;
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  User user = User();
  Color _color1 = Color(0xFFFF8050);
  Color _color2 = Color(0xFFF0F0F0);
  String errorMessage = ""; // Added for displaying error messages

  void initState() {
    super.initState();
    isUserSignedIn();
  }

  void isUserSignedIn() async {
    print("login.dart, in isUserSignedIn");
    user.isUserSignedIn().then((check) {
      print(check);
      if (check) {
        Navigator.pushNamed(context, '/home');
      }
    });
  }

  Future<void> login() async {
    final response = await post(
      Uri.parse('$serverUrl/api/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": emailController.text,
        "password": passWordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final storage = FlutterSecureStorage();
      await storage.write(key: 'access_token', value: (jsonDecode(response.body))['user']['stsTokenManager']['accessToken']);
      await storage.write(key: 'refresh_token', value: (jsonDecode(response.body))['user']['stsTokenManager']['refreshToken']);
      final accessToken = await storage.read(key: 'access_token');
      print("ACCESS TOKENNN");
      print(accessToken);
      print("--------");

      Navigator.pushNamed(context, '/home');
    } else {
      setState(() {
        errorMessage = "Login failed. Please check your credentials.";
      });
    }
  }

  void signUpRoute() {
    Navigator.pushNamed(context, '/sign');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Image.asset('assets/image.png', height: 100),
            Padding(padding: EdgeInsets.only(bottom: 90)),
            TextButton(
              onPressed: () {
                signUpRoute();
              },
              child: Center(
                child: Text(
                  "Create a New Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "borel",
                    color: Colors.black,
                    fontSize: 18.3,
                  ),
                ),
              ),
            ),
            buildEmailField(),
            Padding(padding: EdgeInsets.only(bottom: 8)),
            buildPasswordField(),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                login();
              },
              child: Text(
                'Log in',
                style: TextStyle(
                  fontFamily: "borel",
                  decoration: TextDecoration.underline,
                  fontSize: 18.3,
                ),
              ),
            ),

            // Display error message if there is one
            errorMessage.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget buildEmailField() {
    return SizedBox(
      width: 350,
      child: TextFormField(
        controller: emailController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(50.0),
          ),
          hintText: "Email",
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          filled: true,
          fillColor: _color2,
        ),
      ),
    );
  }

  Widget buildPasswordField() {
    return SizedBox(
      width: 350,
      child: TextFormField(
        obscureText: true,
        controller: passWordController,
        obscuringCharacter: '*',
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(50.0),
          ),
          hintText: "Password",
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          filled: true,
          fillColor: _color2,
        ),
      ),
    );
  }
}
