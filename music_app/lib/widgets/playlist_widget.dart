import 'package:flutter/material.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/pages/playlist_overview_page.dart';
import 'package:music_app/providers/audio_player_provider.dart';
import 'package:music_app/providers/main_provider.dart';
import 'package:provider/provider.dart';

class PlaylistWidget extends StatelessWidget {
  const PlaylistWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final audioGetterProvider = Provider.of<AudioProvider>(context);
    final mainGetterProvider = Provider.of<MainProvider>(context);
    final mainSetterProvider =
        Provider.of<MainProvider>(context, listen: false);
    final audioSetterProvider =
        Provider.of<AudioProvider>(context, listen: false);

    String title = mainGetterProvider.playlistList[index]['title'];

    List<SongModel> songList = mainGetterProvider.playlistList[index]['list'];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        onLongPress: () {
          if (!mainGetterProvider.selectedPlaylistMode) {
            mainSetterProvider.selectedPlaylist
                .add(mainGetterProvider.playlistList[index]);
            mainSetterProvider.changeSelectedPlaylistMode();
          }
        },
        onTap: () {
          //Go Playlist overview page.
          if (mainGetterProvider.selectedPlaylistMode) {
            mainSetterProvider.selectPlaylistItem(
              mainGetterProvider.playlistList[index],
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PlaylistOverviewPage(selectedIndex: index),
              ),
            );
          }
        },
        child: Ink(
          decoration: BoxDecoration(
            color: mainGetterProvider.selectedPlaylist
                    .contains(mainGetterProvider.playlistList[index])
                ? Colors.purple.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: PlaylistImage(songList: songList),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(fontSize: 18),
                            ),
                          ),
                          Text('${songList.length} Song',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          splashRadius: 16,
                          onPressed: () {
                            if (songList.isNotEmpty) {
                              if ((audioGetterProvider.currentPlayList ==
                                      title &&
                                  audioGetterProvider.isPlaySound)) {
                                audioSetterProvider.pauseSong();
                              } else {
                                audioSetterProvider.songModelList = songList;
                                audioSetterProvider.changeSongModelList(
                                    songList, title);
                                audioSetterProvider.playSongWithPath(
                                  audioGetterProvider.songModelList[0],
                                );
                              }
                            }
                          },
                          icon: (audioGetterProvider.currentPlayList == title &&
                                  audioGetterProvider.isPlaySound)
                              ? const Icon(Icons.pause)
                              : const Icon(Icons.play_arrow),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlaylistImage extends StatelessWidget {
  const PlaylistImage({
    Key? key,
    required this.songList,
    this.sizeMultiplier = 0.20,
  }) : super(key: key);

  final List<SongModel> songList;
  final double sizeMultiplier;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(16),
      ),
      child: songList.isEmpty
          ? SizedBox(
              height: MediaQuery.of(context).size.height * sizeMultiplier,
              width: MediaQuery.of(context).size.height * sizeMultiplier,
              child: const Image(
                image: AssetImage(
                  'assets/images/ic_note.jpg',
                ),
                fit: BoxFit.cover,
              ),
            )
          : songList[0].image.runtimeType == String
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * sizeMultiplier,
                  width: MediaQuery.of(context).size.height * sizeMultiplier,
                  child: const Image(
                    image: AssetImage(
                      'assets/images/ic_note.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height * sizeMultiplier,
                  width: MediaQuery.of(context).size.height * sizeMultiplier,
                  child: Image.memory(
                    songList[0].image,
                    fit: BoxFit.cover,
                  ),
                ),
    );
  }
}
