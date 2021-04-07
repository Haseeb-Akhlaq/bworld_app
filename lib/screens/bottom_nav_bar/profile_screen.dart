import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatelessWidget {
  static const route = '/profileScreen';
  logout() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    await FirebaseAuth.instance.signOut();
    print('signouted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.yellow,
          child: TextButton(
            child: Text('logout'),
            onPressed: () async {
              await logout();
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
