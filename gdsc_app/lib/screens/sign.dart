import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gdsc_app/screens/profile.dart';
import 'package:http/http.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final usernameController = TextEditingController();

  bool isChecked = false;
  Color _color1 = Color(0xFFFF8050);
  Color _color2 = Color(0xFFF0F0F0);

  String errorMessage = '';

  bool isValidEmail(input) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(input);
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

    // Perform the account creation logic
    final response = await post(
      Uri.parse('http://10.0.2.2:3000/api/users/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": emailController.text,
        "password": passWordController.text,
        "name": usernameController.text,
        "isOwner": isChecked ? "true" : "false"
      }),
    );

    if (response.statusCode == 200) {
      if (isChecked) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ),
        );
      }
      Navigator.pushNamed(context, '/home');
    } else {
      // Handle other error cases
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey('error') &&
          responseData['error']['code'] == 'auth/invalid-email') {
        // Show an error message for invalid email from Firebase
        setState(() {
          errorMessage = 'Invalid email. Please check your email address.';
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
            Padding(padding: EdgeInsets.only(bottom: 90)),
            // Display error message
            if (errorMessage.isNotEmpty)
              Center(
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            buildNameWidget(),
            Padding(padding: EdgeInsets.only(bottom: 8)),
            buildEmailWidget(),
            Padding(padding: EdgeInsets.only(bottom: 8)),
            buildPasswordWidget(),
            Padding(padding: EdgeInsets.only(bottom: 8)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Are you a club owner?',
                    style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 2.0,
                        color: Colors.black,
                        fontFamily: 'Borel')),
                Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  side: MaterialStateBorderSide.resolveWith(
                          (states) => BorderSide(width: 1.0, color: Colors.black)),
                  checkColor: Colors.black,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
              ],
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              onPressed: () {
                createAccount();
              },
              child: Text('Sign up',
                  style: TextStyle(
                      fontFamily: "borel",
                      decoration: TextDecoration.underline,
                      color: Colors.black,
                      fontSize: 18.3)),
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
}
