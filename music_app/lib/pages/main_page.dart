import 'package:flutter/material.dart';
import 'package:music_app/pages/all_songs_page.dart';
import 'package:music_app/pages/browse_page.dart';
import 'package:music_app/pages/now_playing_page.dart';
import 'package:music_app/providers/audio_player_provider.dart';
import 'package:music_app/providers/main_provider.dart';
import 'package:music_app/utils/color_utils.dart';
import 'package:provider/provider.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isManagePermissionGranted = false;
  bool isExternalPermissionGranted = false;

  int _selectedIndex = 0;
  PageController controller = PageController();

  late MainProvider mainProvider;
  late AudioProvider audioProvider;

  @override
  void initState() {
    mainProvider = Provider.of<MainProvider>(context, listen: false);
    audioProvider = Provider.of<AudioProvider>(context, listen: false);
    loadSongs();
    super.initState();
  }

  loadSongs() async {
    await mainProvider.loadSongs();
    await audioProvider.setSongModelList(
      mainProvider.songModelList,
      mainProvider.allPageList,
    );
    await audioProvider.preparePlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: ColorUtils.gradientAppBar),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          children: const [
            BrowsePage(),
            AllSongsPage(),
            NowPlayingPage(),
          ],
        ),
        bottomNavigationBar: _tabbar(),
      ),
    );
  }

  _tabbar() {
    return SlidingClippedNavBar(
      backgroundColor: Colors.white,
      onButtonPressed: (index) {
        setState(() {
          _selectedIndex = index;
        });
        controller.animateToPage(_selectedIndex,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOutQuad);
      },
      iconSize: 30,
      inactiveColor: Colors.black12,
      activeColor: Colors.purple,
      selectedIndex: _selectedIndex,
      barItems: [
        BarItem(
          icon: Icons.featured_play_list_outlined,
          title: 'Playlists',
        ),
        BarItem(
          icon: Icons.music_note_outlined,
          title: 'All Songs',
        ),
        BarItem(
          title: 'Now Playing',
          icon: Icons.play_arrow_outlined,
        ),

        /// Add more BarItem if you want
      ],
    );
  }
}
