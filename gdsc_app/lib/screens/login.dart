import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  void login(){
    if (emailController.text == passWordController.text){
          Navigator.pushNamed(context, '/feed');
      }
    }
    void signUpRoute(){
      Navigator.pushNamed(context, '/sign');

    }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Text('Soshal',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: Colors.grey[600],
                        fontFamily: 'Borel'
                    )
                )
            ),
            TextField(
                obscureText: true,
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintStyle: TextStyle(color: Colors.grey[800], fontFamily: "borel"),
                  labelText: "Email",
                  hintText: "Email",
                  fillColor: Colors.white70,
                )
            ),
            Padding(
                padding: EdgeInsets.all(16.0)
            ),
            TextField(
                obscureText: true,
                controller: passWordController,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintStyle: TextStyle(color: Colors.grey[800], fontFamily: "borel"),
                  labelText: "Password",
                  hintText: "Password",
                  fillColor: Colors.white70,
                )
            ),

            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              onPressed: () {login(); },
              child: Text('Log in',
                  style: TextStyle(
                      fontFamily: "borel"
                  )
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              onPressed: () {signUpRoute(); },
              child: Text("Don't have an account?",
                  style: TextStyle(
                      fontFamily: "borel"
                  )
              ),
            )
          ],
        )
    );
  }
}


