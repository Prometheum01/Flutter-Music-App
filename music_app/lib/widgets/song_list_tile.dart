import 'package:flutter/material.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/providers/audio_player_provider.dart';
import 'package:music_app/providers/main_provider.dart';
import 'package:music_app/widgets/wave_form.dart';
import 'package:provider/provider.dart';

class SongListTile extends StatefulWidget {
  const SongListTile({
    Key? key,
    required this.index,
    required this.allSongList,
    required this.title,
  }) : super(key: key);

  final int index;
  final List<SongModel> allSongList;
  final String title;

  @override
  State<SongListTile> createState() => _SongListTileState();
}

class _SongListTileState extends State<SongListTile> {
  @override
  Widget build(BuildContext context) {
    final audioGetterProvider = Provider.of<AudioProvider>(context);
    final audioSetterProvider =
        Provider.of<AudioProvider>(context, listen: false);
    final mainSetterProvider =
        Provider.of<MainProvider>(context, listen: false);
    final mainGetterProvider = Provider.of<MainProvider>(
      context,
    );

    bool isSelected = mainGetterProvider.selectedList
        .contains(widget.allSongList[widget.index]);

    return Material(
      elevation: 0,
      color: Colors.white,
      child: InkWell(
        onLongPress: () {
          if (!mainGetterProvider.selectedMode) {
            mainSetterProvider.changeSelectedMode();
            mainSetterProvider.selectItem(widget.allSongList[widget.index]);
          }
        },
        onTap: () {
          if (mainGetterProvider.selectedMode) {
            mainSetterProvider.selectItem(widget.allSongList[widget.index]);
          } else {
            if (audioGetterProvider.currenctSoundPath !=
                    widget.allSongList[widget.index].path ||
                audioGetterProvider.currenctSoundPath == '') {
              for (SongModel s in widget.allSongList) {
                if (widget.allSongList[widget.index].path == s.path) {
                  audioGetterProvider.setCurrentSong(s);
                }
              }
              audioSetterProvider.changeSongModelList(
                widget.allSongList,
                widget.title,
              );
              audioGetterProvider
                  .playSongWithPath(widget.allSongList[widget.index]);
            }
          }
        },
        child: ListTile(
          selected: isSelected ? true : false,
          selectedTileColor: Colors.purple.withOpacity(0.15),
          contentPadding: const EdgeInsets.all(8),
          trailing: listTileTrailing(
              context, widget.allSongList[widget.index], isSelected),
          leading: SizedBox(
            height: 64,
            width: 64,
            child: (widget.allSongList[widget.index].image.runtimeType ==
                    String)
                ? Image.asset(widget.allSongList[widget.index].image.toString())
                : CircleAvatar(
                    backgroundImage: MemoryImage(
                      widget.allSongList[widget.index].image,
                    ),
                  ),
          ),
          subtitle: Text(
            widget.allSongList[widget.index].artist.toString(),
            style: Theme.of(context).textTheme.subtitle2?.copyWith(
                color: (audioGetterProvider.currentSong.path ==
                        widget.allSongList[widget.index].path)
                    ? Colors.purple.withOpacity(0.5)
                    : Colors.black.withOpacity(0.5)),
          ),
          title: listTileTitle(widget.index, context),
        ),
      ),
    );
  }

  listTileTrailing(BuildContext context, SongModel songModel, bool isSelected) {
    final audioGetterProvider = Provider.of<AudioProvider>(
      context,
    );
    final mainGetterProvider = Provider.of<MainProvider>(
      context,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: mainGetterProvider.selectedMode
          ? Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.1,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black26),
                shape: BoxShape.circle,
                color: isSelected
                    ? Colors.purple.withOpacity(0.25)
                    : Colors.transparent,
              ),
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              child: audioGetterProvider.currenctSoundPath == songModel.path
                  ? WaveFormForSong(
                      audioGetterProvider: audioGetterProvider,
                    )
                  : const SizedBox.shrink(),
            ),
    );
  }

  Text listTileTitle(int index, BuildContext context) {
    final audioGetterProvider = Provider.of<AudioProvider>(context);
    return Text(
      widget.allSongList[index].name,
      style: Theme.of(context).textTheme.headline6?.copyWith(
          color: (audioGetterProvider.currentSong.path ==
                  widget.allSongList[index].path)
              ? Colors.purple
              : Colors.black),
      overflow: TextOverflow.ellipsis,
      softWrap: true,
    );
  }
}

class SelectableSongListTile extends StatefulWidget {
  const SelectableSongListTile(
      {Key? key, required this.index, required this.list})
      : super(key: key);

  final int index;
  final List<SongModel> list;

  @override
  State<SelectableSongListTile> createState() => _SelectableSongListTileState();
}

class _SelectableSongListTileState extends State<SelectableSongListTile> {
  @override
  Widget build(BuildContext context) {
    final mainSetterProvider =
        Provider.of<MainProvider>(context, listen: false);
    final mainGetterProvider = Provider.of<MainProvider>(
      context,
    );

    bool isSelected =
        mainGetterProvider.selectedList.contains(widget.list[widget.index]);

    List<SongModel> allSongList = widget.list;
    int index = widget.index;

    return Material(
      elevation: 0,
      color: Colors.white,
      child: InkWell(
        onTap: () {
          if (!isSelected) {
            mainSetterProvider.selectedList.add(allSongList[index]);
          } else {
            mainSetterProvider.selectedList.remove(
              allSongList[index],
            );
          }
          mainSetterProvider.notifyListeners();
        },
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          selected: isSelected,
          selectedTileColor: Colors.purple.withOpacity(0.15),
          leading: (allSongList[index].image.runtimeType == String)
              ? SizedBox(
                  height: 64,
                  width: 64,
                  child: Image.asset(allSongList[index].image.toString()),
                )
              : SizedBox(
                  height: 64,
                  width: 64,
                  child: CircleAvatar(
                    backgroundImage: MemoryImage(
                      allSongList[index].image,
                    ),
                  ),
                ),
          subtitle: Text(allSongList[index].album,
              style: Theme.of(context).textTheme.subtitle2),
          title: listTileTitle(index, context),
        ),
      ),
    );
  }

  Text listTileTitle(int index, BuildContext context) {
    return Text(
      widget.list[index].name,
      style: Theme.of(context).textTheme.headline6,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
    );
  }
}
