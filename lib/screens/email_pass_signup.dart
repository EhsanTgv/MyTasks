import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytask/config/config.dart';

class EmailPassSignupScreen extends StatefulWidget {
  @override
  _EmailPassSignupScreenState createState() => _EmailPassSignupScreenState();
}

class _EmailPassSignupScreenState extends State<EmailPassSignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _signUp() {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text("Success"),
              content: Text("Sign Up process is done, now you can sign in"),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text("Error"),
              content: Text(error.message.toString()),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text("Error"),
            content: Text("Please provide email & password"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Email Sign Up"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 40),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    hintText: "Write your Email here"),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 10),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    hintText: "Write your password here"),
                obscureText: true,
              ),
            ),
            InkWell(
              onTap: () {
                _signUp();
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                child: Center(
                  child: Text(
                    "Sign Up Using Email",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
