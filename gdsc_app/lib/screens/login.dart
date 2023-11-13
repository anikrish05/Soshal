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
  Color _color1 = Color(0xFFFF8050);
  Color _color2 = Color(0xFFF0F0F0);
  @override

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          //TODO: Change the alignment
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:8),
                  child: Icon(Icons.location_pin,
                    color: _color1,
                    size: 50.3
                  ),
                ),
                Text('Soshal',
                    style: TextStyle(
                        fontSize: 50.3,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: _color1,
                        fontFamily: 'Borel'
                    )
                ),
              ],
            ),
            TextButton(
              onPressed: () {signUpRoute(); },
              child: Text("create a new account",
                  style: TextStyle(
                      fontFamily: "borel",
                      color: Colors.black,
                      fontSize: 18.3
                  )
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
                padding: EdgeInsets.all(5.0)
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
                      borderSide: BorderSide(width: 0.0)
                    ),
                    labelText: "Password",
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
                    fontSize: 18.3
                  )
              ),
            ),

          ],
        )
    );
  }
}


