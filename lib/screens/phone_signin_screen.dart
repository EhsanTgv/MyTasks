import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mytask/config/config.dart';

class PhoneSignInScreen extends StatefulWidget {
  @override
  _PhoneSignInScreenState createState() => _PhoneSignInScreenState();
}

class _PhoneSignInScreenState extends State<PhoneSignInScreen> {
  PhoneNumber _phoneNumber;

  String _message;
  String _verificationId;

  bool _isSMSsent = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _smsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Sign In"),
      ),
      body: SingleChildScrollView(
        child: AnimatedContainer(
          duration: Duration(microseconds: 300),
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 20),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: InternationalPhoneNumberInput(
                  onInputChanged: (phoneNumberText) {
                    _phoneNumber = phoneNumberText;
                  },
                  inputBorder: OutlineInputBorder(),
                ),
              ),
              _isSMSsent
                  ? Container(
                      margin: EdgeInsets.all(10),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "OTP here",
                          labelText: "OTP",
                        ),
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                      ),
                    )
                  : Container(),
              !_isSMSsent
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          _isSMSsent = true;
                        });
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
                            "Sent OTP",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () {},
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
                            "Verify OTP",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
