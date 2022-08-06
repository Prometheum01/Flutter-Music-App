import 'package:flutter/material.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/providers/main_provider.dart';
import 'package:music_app/utils/text_utils.dart';
import 'package:music_app/widgets/custom_divider.dart';
import 'package:music_app/widgets/playlist_widget.dart';
import 'package:provider/provider.dart';

class SelectedBottomSheet extends StatelessWidget {
  const SelectedBottomSheet({
    Key? key,
    required this.songList,
    required this.secondItemType,
  }) : super(key: key);

  final List<SongModel> songList;
  //0: Remove, 1: add new songs for playlist.
  final int secondItemType;

  @override
  Widget build(BuildContext context) {
    final mainGetterProvider = Provider.of<MainProvider>(context);
    final mainSetterProvider =
        Provider.of<MainProvider>(context, listen: false);

    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height * 0.05,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(primary: Colors.purple),
              onPressed: () {
                mainSetterProvider.resetSelectedThings();
              },
              child: Text(TextUtils.closeText),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: secondItemType == 0
                ? TextButton(
                    style: TextButton.styleFrom(primary: Colors.purple),
                    onPressed: () {
                      mainSetterProvider.removeSelectedItem(songList);
                    },
                    child: Text(TextUtils.removeText),
                  )
                : TextButton(
                    style: TextButton.styleFrom(primary: Colors.purple),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          List playlistList = mainGetterProvider.playlistList;
                          return AlertDialog(
                            content: playlistList.isEmpty
                                ? Container()
                                : SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.75,
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    child: ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            const CustomDividerForSongBuilder(),
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: playlistList.length,
                                        itemBuilder: (context, index) {
                                          String title =
                                              playlistList[index]['title'];
                                          List<SongModel> list =
                                              playlistList[index]['list'];
                                          return ListTile(
                                            onTap: () {
                                              mainSetterProvider
                                                  .addSelectedItem(
                                                list,
                                              );
                                              Navigator.pop(context);
                                            },
                                            leading: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.075,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.075,
                                              child:
                                                  PlaylistImage(songList: list),
                                            ),
                                            title: Text(
                                              playlistList[index]['title'],
                                            ),
                                            trailing:
                                                Text('${list.length} songs'),
                                          );
                                        }),
                                  ),
                          );
                        },
                      );
                    },
                    child: Text(TextUtils.addText),
                  ),
          ),
        ],
      ),
    );
  }
}
