import 'package:flutter/material.dart';

import './podcast_screen.dart';
import './select_screen.dart';
import './youtube_videos_screen.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/homeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  PageController _pageController = PageController();

  void changeIndex({index}) {
    setState(() {
      selectedIndex = index;
      _pageController.animateToPage(selectedIndex,
          duration: Duration(microseconds: 600), curve: Curves.linear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
            _pageController.animateToPage(selectedIndex,
                duration: Duration(microseconds: 600), curve: Curves.linear);
          });
        },
        backgroundColor: Colors.purple,
        selectedItemColor: Colors.white,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        unselectedItemColor: Colors.white,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.wifi_tethering_rounded), label: 'Podcasts'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.video_collection,
              ),
              label: 'Youtube'),
        ],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: [
          SelectScreen(
            changeScreen: changeIndex,
          ),
          PodcastsScreen(
            changeScreen: changeIndex,
          ),
          YoutubeVideosScreen(
            changeScreen: changeIndex,
          ),
        ],
      ),
    );
  }
}
