import 'package:flutter/material.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/providers/audio_player_provider.dart';
import 'package:music_app/providers/main_provider.dart';
import 'package:music_app/utils/decoration_utils.dart';
import 'package:music_app/utils/text_utils.dart';
import 'package:music_app/widgets/custom_divider.dart';
import 'package:music_app/widgets/song_list_tile.dart';
import 'package:provider/provider.dart';

class SelectSongPage extends StatefulWidget {
  const SelectSongPage({Key? key, required this.playlist}) : super(key: key);

  final Map playlist;

  @override
  State<SelectSongPage> createState() => _SelectSongPageState();
}

class _SelectSongPageState extends State<SelectSongPage> {
  @override
  Widget build(BuildContext context) {
    final audioGetterProvider = Provider.of<AudioProvider>(context);
    List<SongModel> seesPage = [];
    List<SongModel> selectedList = widget.playlist['list'];
    for (SongModel songModel in audioGetterProvider.allPageSongList) {
      if (!selectedList.contains(songModel)) {
        seesPage.add(songModel);
      }
    }
    return Container(
      decoration: DecorationUtils.appBarDecoration,
      child: Scaffold(
        appBar: _appBar(context),
        backgroundColor: Colors.transparent,
        body: Container(
          color: Colors.white,
          child: ListView.separated(
            separatorBuilder: (context, index) =>
                const CustomDividerForSongBuilder(),
            itemCount: seesPage.length,
            itemBuilder: (context, index) {
              return SelectableSongListTile(
                index: index,
                list: seesPage,
              );
            },
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        TextUtils.addText,
        style: Theme.of(context)
            .textTheme
            .headline5
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      leading: IconButton(
        onPressed: () {
          final mainSetterProvider =
              Provider.of<MainProvider>(context, listen: false);

          mainSetterProvider.resetSelectedThings();
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        Center(
          child: IconButton(
            onPressed: () {
              final mainSetterProvider =
                  Provider.of<MainProvider>(context, listen: false);

              List<SongModel> list = widget.playlist['list'];

              list.addAll(mainSetterProvider.selectedList);

              mainSetterProvider.selectedList = [];
              mainSetterProvider.notifyListeners();

              Navigator.pop(context);
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.done_outlined,
            ),
          ),
        )
      ],
    );
  }
}
