import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PodcastsScreen extends StatefulWidget {
  final Function changeScreen;

  const PodcastsScreen({this.changeScreen});
  @override
  _PodcastsScreenState createState() => _PodcastsScreenState();
}

class _PodcastsScreenState extends State<PodcastsScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

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
      appBar: AppBar(
        title: Text('B-ZONE'),
        centerTitle: true,
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            widget.changeScreen(index: 0);
          },
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (content) =>
                [PopupMenuItem(value: 1, child: Text("Log out"))],
            onSelected: (value) async {
              if (value == 1) {
                await logout();
              }
            },
          )
        ],
      ),
      body: WebView(
          initialUrl:
              'https://podcasts.apple.com/us/podcast/the-b-zone-with-traci-s-campbell/id1503956678',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          }),
    );
  }
}
