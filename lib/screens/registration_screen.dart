import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String emailAddress = '';
  String password = '';
  final _auth = FirebaseAuth.instance;
  Widget buttonChild = Text(
    'Register',
    style: TextStyle(color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: true,
              onChanged: (value) {
                emailAddress = value;
              },
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              keyboardType: TextInputType.visiblePassword,
              textAlign: TextAlign.center,
              obscureText: true,
              enableSuggestions: false,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              child: buttonChild,
              color: Colors.blueAccent,
              onButtonPressed: () async {
                setState(() {
                  buttonChild = SpinKitFadingCircle(
                    color: Colors.white,
                    size: 30.0,
                  );
                });
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                    email: emailAddress,
                    password: password,
                  );
                  if (newUser != null) {
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                } catch (e) {
                  print(e);
                } finally {
                  setState(() {
                    buttonChild = Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    );
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
