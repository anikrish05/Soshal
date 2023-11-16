import 'package:flutter/material.dart';
class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isChecked = false;
  Color _color1 = Color(0xFFFF8050);
  Color _color2 = Color(0xFFF0F0F0);

  bool isValidEmail(input) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(input);
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Sign Up',
                style: TextStyle(
                    fontSize: 50.3,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: _color1,
                    fontFamily: 'Borel'
                )
            ),
            SizedBox(
              width: 350,
              height: 40,
              child: TextFormField(
                  validator: (input) => isValidEmail(input) ? null : "Check your email",
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
                    ),
                    labelText: "Password",
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
                  controller: confirmPasswordController,
                  obscuringCharacter: '*',
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    labelText: "Password",
                    filled: true,
                    fillColor: _color2,
                  )
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Are you a club owner?',
                    style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 2.0,
                        color: Colors.black,
                        fontFamily: 'Borel'
                    )
                ),
                Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  side: MaterialStateBorderSide.resolveWith(
                        (states) => BorderSide(width: 1.0, color: Colors.black),
                  ),
                  checkColor: Colors.black,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: isChecked,
                  onChanged: (bool? value){
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
              onPressed: () { },
              child: Text('Sign up',
                  style: TextStyle(
                      fontFamily: "borel",
                    color: Colors.black,
                    fontSize: 18.3
                  )
              ),
            ),
          ],
        )
    );
  }
}

