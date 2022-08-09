import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/widgets/now_playing_page_buttons_row.dart';

class AudioProvider extends ChangeNotifier {
  bool isPlaySound = false;

  String currenctSoundPath = '';

  late List<SongModel> songModelList;
  late List<SongModel> allPageSongList;

  //Punk, Pop, all;
  String currentPlayList = 'all';

  SongModel currentSong = SongModel(
      name: '', path: '', album: '', artist: [''], image: '', duration: 1);

  late AnimationController animationController;

  late int songDuration = 0;

  ReleaseSituation releaseMode = ReleaseSituation.off;

  bool shuffleMode = false;

  final audioPlayer = AudioPlayer();

  preparePlayer() async {
    audioPlayer.setVolume(0.5);
    audioPlayer.setPlaybackRate(1);
    audioPlayer.onPlayerComplete.listen((event) {
      if (releaseMode == ReleaseSituation.single) {
        playSongWithPath(currentSong);
      } else if (getIndex(currentSong) == songModelList.length - 1) {
        if (releaseMode == ReleaseSituation.multi) {
          playSongWithPath(songModelList[0]);
        }
        stopSong();
      } else {
        playSongWithPath(songModelList[getIndex(currentSong) + 1]);
      }
    });
    audioPlayer.onDurationChanged.listen((event) async {
      Duration? duration = await audioPlayer.getCurrentPosition();
      songDuration = (duration?.inSeconds ?? -1);
      notifyListeners();
    });
  }

  setAnimationController(AnimationController x) {
    animationController = x;
    if (isPlaySound) {
      animationController.animateTo(1);
    }
  }

  setSongModelList(List<SongModel> list, List<SongModel> allPageList) {
    songModelList = list;
    allPageSongList = allPageList;

    notifyListeners();
  }

  setCurrentSong(SongModel song) {
    currentSong = song;
    notifyListeners();
  }

  int getIndex(SongModel songModel) {
    int index = 0;
    for (SongModel song in songModelList) {
      if (song == songModel) {
        return index;
      }
      index++;
    }
    return index;
  }

  void changeSongModelList(List<SongModel> newList, String title) {
    songModelList = List.from(newList);
    currentPlayList = title;
    notifyListeners();
  }

  void changeReleaseMode() {
    print(releaseMode.name + 'first');
    if (releaseMode == ReleaseSituation.off) {
      releaseMode = ReleaseSituation.single;
    } else if (releaseMode == ReleaseSituation.single) {
      releaseMode = ReleaseSituation.multi;
    } else if (releaseMode == ReleaseSituation.multi) {
      releaseMode = ReleaseSituation.off;
    }
    notifyListeners();
    print(releaseMode.name + 'second');
  }

  Future<void> changeShuffleMode() async {
    shuffleMode = !shuffleMode;
    if (!shuffleMode) {
      songModelList
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } else {
      songModelList.shuffle();
    }
    notifyListeners();
  }

  void changePosition(Duration position) {
    audioPlayer.seek(position);
    notifyListeners();
  }

  void stopSong() async {
    isPlaySound = false;
    await animationController.animateTo(0);
    await audioPlayer.stop();
    notifyListeners();
  }

  void playSongWithPath(SongModel songModel) async {
    await audioPlayer.play(
      DeviceFileSource(songModel.path),
    );
    currenctSoundPath = songModel.path;
    setCurrentSong(songModel);
    isPlaySound = true;
    animationController.forward();

    notifyListeners();
  }

  void pauseSong() async {
    await audioPlayer.pause();
    animationController.reverse();
    changePlayStatus();
  }

  void resumeSong() async {
    await audioPlayer.resume();
    animationController.forward();
    changePlayStatus();
  }

  void changePlayStatus() {
    isPlaySound = !isPlaySound;
    notifyListeners();
  }
}
