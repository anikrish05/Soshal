import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:gdsc_app/classes/user.dart';

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
  @override

  void initState() {
    super.initState();
    isUserSignedIn();
  }
  void isUserSignedIn() async {
    print("in");
    user.isUserSignedIn().then((check){
      print(check);
      if(check){
        Navigator.pushNamed(context, '/home');
      }
    });
  }
  void login() async {
    print("HIIHIHIHI");
    user.signIn(emailController.text, passWordController.text).then((check){
      if(check){
        print("hi");
        Navigator.pushNamed(context, '/home');
      }
    });
  }
  void signUpRoute(){
    Navigator.pushNamed(context, '/sign');

  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Column(
          //TODO: Change the alignment
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/image.png',
              height: 100
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 90)
            ),
            TextButton(
              onPressed: () {signUpRoute(); },
              child: Center(
                child: Text("create a new account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                        fontFamily: "borel",
                        color: Colors.black,
                        fontSize: 18.3,
                    )
                ),
              ),
            ),
            SizedBox(
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
                  )
              ),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 8)
            ),
            SizedBox(
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
                  )
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              onPressed: () {login(); },
              child: Text('Log in',
                  style: TextStyle(
                      fontFamily: "borel",
                    decoration: TextDecoration.underline,
                    fontSize: 18.3
                  )
              ),
            ),


          ],
        )
    );
  }
}


