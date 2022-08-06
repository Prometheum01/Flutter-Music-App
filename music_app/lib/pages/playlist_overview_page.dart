import 'package:flutter/material.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/pages/select_song_page.dart';
import 'package:music_app/providers/main_provider.dart';
import 'package:music_app/utils/decoration_utils.dart';
import 'package:music_app/widgets/custom_divider.dart';
import 'package:music_app/widgets/selected_bottom_sheet.dart';
import 'package:music_app/widgets/song_list_tile.dart';
import 'package:provider/provider.dart';

class PlaylistOverviewPage extends StatefulWidget {
  const PlaylistOverviewPage({Key? key, required this.selectedIndex})
      : super(key: key);

  final int selectedIndex;

  @override
  State<PlaylistOverviewPage> createState() => _PlaylistOverviewPageState();
}

class _PlaylistOverviewPageState extends State<PlaylistOverviewPage> {
  @override
  Widget build(BuildContext context) {
    final mainGetterProvider = Provider.of<MainProvider>(context);
    List<SongModel> songList =
        mainGetterProvider.playlistList[widget.selectedIndex]['list'];
    String title =
        mainGetterProvider.playlistList[widget.selectedIndex]['title'];

    return Container(
      decoration: DecorationUtils.appBarDecoration,
      child: Scaffold(
        appBar: _appBar(context, title),
        bottomSheet: mainGetterProvider.selectedMode
            ? SelectedBottomSheet(
                songList: songList,
                secondItemType: 0,
              )
            : null,
        backgroundColor: Colors.transparent,
        body: Container(
          color: Colors.white,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (context, index) =>
                const CustomDividerForSongBuilder(),
            itemCount: songList.length,
            itemBuilder: (context, index) => SongListTile(
              index: index,
              allSongList: songList,
              title: title,
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    final mainGetterProvider = Provider.of<MainProvider>(context);
    final mainSetterProvider =
        Provider.of<MainProvider>(context, listen: false);

    Map playlist = mainGetterProvider.playlistList[widget.selectedIndex];

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
          onPressed: () {
            mainSetterProvider.resetSelectedThings();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back)),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headline5
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      actions: [
        Center(
            child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectSongPage(playlist: playlist),
              ),
            );
          },
          icon: const Icon(Icons.add),
        )),
      ],
    );
  }
}
