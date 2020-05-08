import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Image(
              image: AssetImage("assets/logo_round.png"),
              width: 200,
              height: 200,
            )
          ],
        ),
      ),
    );
  }
}
