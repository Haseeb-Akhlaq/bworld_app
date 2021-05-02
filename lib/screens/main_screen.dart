import 'dart:io';
import 'dart:ui';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:starter_app/screens/SignUp_with_email.dart';
import 'package:starter_app/screens/signIn_Screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  void showErrSnackBar(
      {String message = 'Error Occurred', Color background = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: background,
      duration: Duration(seconds: 1),
    ));
  }

  @override
  void initState() {
    if (Platform.isIOS) {
      AppleSignIn.onCredentialRevoked.listen((_) {
        print("Credentials revoked");
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(children: [
        BackgroundImage(),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 350,
                    ),
                    Positioned(
                      top: 300,
                      left: 97,
                      child: Column(
                        children: [
                          Text(
                            'B World',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Live Leam Level Up !',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                FacebookButton(showErr: showErrSnackBar),
                SizedBox(
                  height: 15,
                ),
                GoogleButton(showErr: showErrSnackBar),
                SizedBox(
                  height: 15,
                ),
                if (Platform.isIOS)
                  AppleButton(
                    showErr: showErrSnackBar,
                  ),
                SizedBox(
                  height: 40,
                ),
                EmailButton(),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already Have an account ?'),
                    SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, LoginScreen.route);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class AppleButton extends StatelessWidget {
  final Function showErr;

  const AppleButton({this.showErr});

  appleLogin() async {
    if (await AppleSignIn.isAvailable()) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          print(result.credential.user);
          break;
        case AuthorizationStatus.error:
          print("Sign in failed: ${result.error.localizedDescription}");
          throw 'error';
          break;
        case AuthorizationStatus.cancelled:
          print('User cancelled');
          throw 'error';
          break;
      }
    } else {
      throw 'error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          await appleLogin();
        } catch (e) {
          showErr();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30,
                width: 30,
                child: Image.asset('assets/apple.png'),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'Sign In with Apple',
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EmailButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, SignUpWithEmailScreen.route);
      },
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Sign Up with Email',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class GoogleButton extends StatelessWidget {
  final Function showErr;

  const GoogleButton({this.showErr});

  signInWithGoogle() async {
    print(' step 1--------------------------------------------');
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount googleAccount = await googleSignIn.signIn();

    print(
        '${googleAccount.authentication}--------------------------------------------');
    if (googleAccount != null) {
      GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      print(' step 2--------------------------------------------');
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        print(
            '${googleAuth.idToken}--------------------------------------------');
        final authResult = await FirebaseAuth.instance.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        print(
            '${authResult.user}-----------------------------------------user here');

        //return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Authentication Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign In aborted by user',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          await signInWithGoogle();
        } catch (e) {
          showErr();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 35,
                width: 35,
                child: Image.asset('assets/googlelogo.png'),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'Sign Up with Google',
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FacebookButton extends StatelessWidget {
  final Function showErr;

  const FacebookButton({this.showErr});

  signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final facebookAccount =
        await facebookLogin.logIn(['public_profile', 'email']);

    if (facebookAccount != null &&
        facebookAccount.status == FacebookLoginStatus.loggedIn) {
      final authResult = await FirebaseAuth.instance.signInWithCredential(
        FacebookAuthProvider.credential(facebookAccount.accessToken.token),
      );
      print(authResult.user);
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign In aborted by user',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          await signInWithFacebook();
        } catch (e) {
          showErr();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
            color: Color(0xff5890FF), borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                child: Image.asset('assets/facebooklogo.png'),
              ),
              SizedBox(
                width: 20,
              ),
              Text('Sign Up with facebook')
            ],
          ),
        ),
      ),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/backgroundImage.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
