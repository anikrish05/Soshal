import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gdsc_app/screens/profile.dart';
import 'package:http/http.dart';
import '../app_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final serverUrl = AppConfig.serverUrl;

int currYear = DateTime.now().year;

List<int> list = <int>[
  currYear,
  currYear + 1,
  currYear + 2,
  currYear + 3,
  currYear + 4
];

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final usernameController = TextEditingController();
  int gradYear = list.first;

  Color _color1 = Color(0xFFFF8050);
  Color _color2 = Color(0xFFF0F0F0);

  String errorMessage = '';

  bool isValidEmail(String input) {
    // Check if the email is a valid UCSC email
    bool isValidFormat = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(input);

    bool containsUCSCDomain = input.endsWith("@ucsc.edu");

    return isValidFormat && containsUCSCDomain;
  }

  void createAccount() async {
    // Check if the email is a valid UCSC email
    if (!isValidEmail(emailController.text)) {
      // Show an error message for an invalid email
      setState(() {
        errorMessage = 'Invalid email. Please use a UCSC email.';
      });
      return;
    }

    // Check if the password meets the minimum length requirement
    if (passWordController.text.length < 6) {
      // Show an error message for a weak password
      setState(() {
        errorMessage = 'Password should be at least 6 characters.';
      });
      return;
    }

    // Perform the account creation logic
    final _firebaseMessaging = FirebaseMessaging.instance;
    await _firebaseMessaging.requestPermission();

    final response = await post(
      Uri.parse('$serverUrl/api/users/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "email": emailController.text,
        "password": passWordController.text,
        "name": usernameController.text,
        "classOf": gradYear,
        "token": await _firebaseMessaging.getToken()
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/home');
    } else {
      // Handle other error cases
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData);
      if (responseData.containsKey('error') &&
          responseData['error']['code'] == 'auth/invalid-email') {
        // Show an error message for invalid email from Firebase
        setState(() {
          errorMessage = 'Invalid email. Please check your email address.';
        });
      } else if (responseData.containsKey('error') &&
          responseData['error']['code'] == 'auth/weak-password') {
        // Show an error message for a weak password
        setState(() {
          errorMessage = 'Password should be at least 6 characters.';
        });
      } else {
        // Show a generic error message for other errors
        setState(() {
          errorMessage = 'An error occurred. Please try again later.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.white;
      }
      return Colors.white;
    }

    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Image.asset('assets/image.png', height: 100),
            Padding(padding: EdgeInsets.only(bottom: 80)),
            // Display error message
            if (errorMessage.isNotEmpty)
              Center(
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildNameWidget(),
                Padding(padding: EdgeInsets.only(bottom: 8)),
                buildEmailWidget(),
                Padding(padding: EdgeInsets.only(bottom: 8)),
                buildPasswordWidget(),
                Padding(padding: EdgeInsets.only(bottom: 8)),
                buildClassOfWidget(),
                Padding(padding: EdgeInsets.only(bottom: 20)),
              ],
            ),
            SizedBox(height: 18),
            Center(
              // Center added here
              child: SizedBox(
                height: 45,
                width: 200,
                child: Padding(
                  // Add padding here
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Center(
                    // Center added here
                    child: SizedBox(
                      width: 150, // This sets the width of the button
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: _color1, // _color1 used here
                          padding: EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                50), // Set the border radius
                          ),
                        ),
                        onPressed: () {
                          createAccount();
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
             // Add padding here
            Row(
              mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
              children: [
                Icon(
                  Icons.arrow_back_rounded,
                  color: _color1,

                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/login'); // Navigate to login.dart page
                  },
                  child: Text('Back to Login',

                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      )
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNameWidget() {
    return SizedBox(
      width: 350,
      child: TextFormField(
          controller: usernameController,
          obscuringCharacter: '*',
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(50.0),
            ),
            hintText: "Name",
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            filled: true,
            fillColor: _color2,
          )),
    );
  }

  Widget buildEmailWidget() {
    return SizedBox(
      width: 350,
      child: TextFormField(
          controller: emailController,
          obscuringCharacter: '*',
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(50.0),
            ),
            hintText: "Email",
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            filled: true,
            fillColor: _color2,
          )),
    );
  }

  Widget buildPasswordWidget() {
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
          )),
    );
  }

  Widget buildClassOfWidget() {
    return Container(
        width: 350,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: Colors.grey[200], // Change the color as needed
        ),
        child: DropdownButton<int>(
          value: gradYear,
          alignment: AlignmentDirectional.topStart,
          hint: Text('Select Graduation Year'),
          isExpanded: true,
          borderRadius: BorderRadius.circular(20.0),
          elevation: 16,
          underline: SizedBox(),
          onChanged: (int? value) {
            // This is called when the user selects an item.
            setState(() {
              gradYear = value!;
            });
          },
          items: list.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('Graduation Year: $value', style: TextStyle(color: const Color.fromARGB(255, 104, 104, 104)),),
            );
          }).toList(),
        ));
  }
}
