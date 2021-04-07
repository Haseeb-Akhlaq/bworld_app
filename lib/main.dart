import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:starter_app/screens/SignUp_with_email.dart';
import 'package:starter_app/screens/landing_screen.dart';
import 'package:starter_app/screens/signIn_Screen.dart';

import 'file:///C:/Users/haseeb/AndroidStudioProjects/starter_app/lib/screens/bottom_nav_bar/home_screen.dart';
import 'file:///C:/Users/haseeb/AndroidStudioProjects/starter_app/lib/screens/bottom_nav_bar/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText2: TextStyle(
              color: Colors.white, fontSize: 14.0, fontFamily: 'Hind'),
        ),
        primarySwatch: Colors.blue,
      ),
      home: LandingScreen(),
      routes: {
        SignUpWithEmailScreen.route: (ctx) => SignUpWithEmailScreen(),
        LoginScreen.route: (ctx) => LoginScreen(),
        HomeScreen.route: (ctx) => HomeScreen(),
        ProfileScreen.route: (ctx) => ProfileScreen(),
      },
    );
  }
}
