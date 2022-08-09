import 'package:flutter/material.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/pages/playlist_overview_page.dart';
import 'package:music_app/providers/audio_player_provider.dart';
import 'package:music_app/providers/main_provider.dart';
import 'package:provider/provider.dart';

class PlaylistWidget extends StatefulWidget {
  const PlaylistWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  State<PlaylistWidget> createState() => _PlaylistWidgetState();
}

class _PlaylistWidgetState extends State<PlaylistWidget> {
  late MainProvider mainSetterProvider;

  @override
  void initState() {
    mainSetterProvider = Provider.of<MainProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mainGetterProvider = Provider.of<MainProvider>(context);

    String title = mainGetterProvider.playlistList[widget.index]['title'];

    List<SongModel> songList =
        mainGetterProvider.playlistList[widget.index]['list'];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        onLongPress: () {
          if (!mainGetterProvider.selectedPlaylistMode) {
            mainSetterProvider.selectedPlaylist
                .add(mainGetterProvider.playlistList[widget.index]);
            mainSetterProvider.changeSelectedPlaylistMode();
          }
        },
        onTap: () {
          //Go Playlist overview page.
          if (mainGetterProvider.selectedPlaylistMode) {
            mainSetterProvider.selectPlaylistItem(
              mainGetterProvider.playlistList[widget.index],
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PlaylistOverviewPage(selectedIndex: widget.index),
              ),
            );
          }
        },
        child: Ink(
          decoration: BoxDecoration(
            color: mainGetterProvider.selectedPlaylist
                    .contains(mainGetterProvider.playlistList[widget.index])
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
                      child: _PlaylistTitle(title: title, songList: songList),
                    ),
                    _PlaylistPlayIcon(
                      songList: songList,
                      title: title,
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

class _PlaylistPlayIcon extends StatelessWidget {
  const _PlaylistPlayIcon({
    Key? key,
    required this.songList,
    required this.title,
  }) : super(key: key);

  final List<SongModel> songList;
  final String title;

  @override
  Widget build(BuildContext context) {
    final audioGetterProvider = Provider.of<AudioProvider>(context);
    final audioSetterProvider =
        Provider.of<AudioProvider>(context, listen: false);
    return IconButton(
      splashRadius: 16,
      onPressed: () {
        if (songList.isNotEmpty) {
          if ((audioGetterProvider.currentPlayList == title &&
              audioGetterProvider.isPlaySound)) {
            audioSetterProvider.pauseSong();
          } else {
            audioSetterProvider.songModelList = songList;
            audioSetterProvider.changeSongModelList(songList, title);
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
    );
  }
}

class _PlaylistTitle extends StatelessWidget {
  const _PlaylistTitle({
    Key? key,
    required this.title,
    required this.songList,
  }) : super(key: key);

  final String title;
  final List<SongModel> songList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style:
                Theme.of(context).textTheme.headline5?.copyWith(fontSize: 16),
          ),
        ),
        Text('${songList.length} Song',
            style: Theme.of(context).textTheme.subtitle2),
      ],
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
