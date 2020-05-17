import 'package:cloud_firestore/cloud_firestore.dart';
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

  final Firestore _db = Firestore.instance;

  final TextEditingController _smsController = TextEditingController();

  void _verifyPhoneNumber() async {
    setState(() {
      _message = "";
    });

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCrendential) {
      _auth.signInWithCredential(phoneAuthCrendential);
      setState(() {
        _message = "Received phone auth crendential: $phoneAuthCrendential";
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        _message =
            "Phone number verification failed, code ${authException.code}. Message: ${authException.message}";
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber.phoneNumber,
        timeout: const Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _signInWithPhone() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: _smsController.text);

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    setState(() {
      if (user != null) {
        
        _db.collection("users").document(user.uid).setData(
          {
            "displayName": user.displayName,
            "email": user.email,
            "photoUrl": user.photoUrl,
            "lastSeen": DateTime.now(),
            "signin_method": user.providerId,
          },
        );

        _message = "Successfully signed in, uid: ${user.uid}";
      } else {
        _message = "Sign in faild";
      }
      print(_message);
    });
  }

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
                        controller: _smsController,
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
                        _verifyPhoneNumber();
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
                      onTap: () {
                        _signInWithPhone();
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
