import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:starter_app/screens/main_screen.dart';

import 'file:///C:/Users/haseeb/AndroidStudioProjects/starter_app/lib/screens/bottom_nav_bar/home_screen.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return HomeScreen();
        }
        return MainScreen();
      },
    );
  }
}
