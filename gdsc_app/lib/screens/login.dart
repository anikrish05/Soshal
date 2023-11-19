import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  void login() async {
    await post(Uri.parse('http://10.0.2.2:3000/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": emailController.text,
        "password": passWordController.text
      }),
    ).then((response) => Navigator.pushNamed(context, '/feed')).catchError((onError)=>{
      print(onError)
    });
  }
    void signUpRoute(){
      Navigator.pushNamed(context, '/sign');

    }
  Color _color1 = Color(0xFFFF8050);
  Color _color2 = Color(0xFFF0F0F0);
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        body: Column(
          //TODO: Change the alignment
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/soshalTransparent.png',
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
                        color: Colors.white,
                        fontSize: 18.3,
                    )
                ),
              ),
            ),
            SizedBox(
              width: 350,
              height: 40,
              child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    labelText: "Email",
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
              height: 40,
              child: TextField(
                  obscureText: true,
                  controller: passWordController,
                  obscuringCharacter: '*',
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    hintText: "Password",
                    filled: true,
                    fillColor: _color2,
                  )
              ),
            ),

            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              onPressed: () {login(); },
              child: Text('Log in',
                  style: TextStyle(
                      fontFamily: "borel",
                    fontSize: 18.3
                  )
              ),
            ),

          ],
        )
    );
  }
}


