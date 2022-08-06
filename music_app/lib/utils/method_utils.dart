import 'package:music_app/models/song_model.dart';
import 'package:music_app/providers/audio_player_provider.dart';

class MethodUtils {
  static void backSongMethod(
      AudioProvider audioGetterProvider, AudioProvider audioSetterProvider) {
    SongModel song = audioGetterProvider.currentSong;
    if (audioGetterProvider.currenctSoundPath != '') {
      int index = audioSetterProvider.getIndex(song);

      if (index > 0) {
        audioSetterProvider
            .playSongWithPath(audioGetterProvider.songModelList[index - 1]);
      } else if (index == 0) {
        audioSetterProvider.playSongWithPath(audioGetterProvider
            .songModelList[audioGetterProvider.songModelList.length - 1]);
      }
    }
  }

  static void forwardSongMethod(
      AudioProvider audioGetterProvider, AudioProvider audioSetterProvider) {
    SongModel song = audioGetterProvider.currentSong;
    if (audioGetterProvider.currenctSoundPath != '') {
      int index = audioSetterProvider.getIndex(song);

      if (index < audioGetterProvider.songModelList.length - 1) {
        audioSetterProvider.playSongWithPath(
          audioGetterProvider.songModelList[index + 1],
        );
      } else if (index == audioGetterProvider.songModelList.length - 1) {
        audioSetterProvider.playSongWithPath(
          audioGetterProvider.songModelList[0],
        );
      }
    }
  }
}
