import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:starter_app/models/video_model.dart';
import 'package:starter_app/services/api_services.dart';

import './video_screen.dart';

class YoutubeVideosScreen extends StatefulWidget {
  final Function changeScreen;
  YoutubeVideosScreen({this.changeScreen});
  @override
  _YoutubeVideosScreenState createState() => _YoutubeVideosScreenState();
}

class _YoutubeVideosScreenState extends State<YoutubeVideosScreen> {
  List<Video> _videos;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    setState(() {
      _isLoading = true;
    });
    final videos = await APIService.instance.fetchVideosFromPlaylist(
        playlistId: 'PLmtE6eFAt40jyUsMpX4y9McWndj8L4-IE');
    setState(() {
      _videos = videos;
      _isLoading = false;
    });
  }

  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(
            id: video.id,
            title: video.title,
            description: video.description,
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        height: 180.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              width: 150.0,
              image: NetworkImage(video.thumbnailUrl),
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Text(
                video.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        title: Text('BIBO Weekly'),
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _videos.length,
              itemBuilder: (BuildContext context, int index) {
                Video video = _videos[(_videos.length - 1) - index];
                return _buildVideo(video);
              },
            ),
    );
  }
}
