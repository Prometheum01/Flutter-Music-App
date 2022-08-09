import 'package:flutter/material.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/utils/decoration_utils.dart';
import 'package:music_app/utils/method_utils.dart';
import 'package:music_app/utils/text_utils.dart';
import 'package:music_app/widgets/animated_play_pause.dart';
import 'package:music_app/widgets/button_with_material.dart';
import 'package:music_app/widgets/duration_text.dart';
import 'package:provider/provider.dart';

import '../providers/audio_player_provider.dart';

class NowPlayingContainer extends StatelessWidget {
  const NowPlayingContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioGetterProvider = Provider.of<AudioProvider>(context);
    final audioSetterProvider =
        Provider.of<AudioProvider>(context, listen: false);

    SongModel song = audioGetterProvider.currentSong;

    return Container(
      height: MediaQuery.of(context).size.height * 0.125,
      decoration: DecorationUtils.nowPlayingContainerBoxDecoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _SongInfoColum(),
            Row(
              children: [
                ButtonWithMaterial(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.purple,
                  ),
                  function: () {
                    //Back Music
                    MethodUtils.backSongMethod(
                        audioGetterProvider, audioSetterProvider);
                  },
                ),
                AnimatedPlayPauseButton(path: song.path),
                ButtonWithMaterial(
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.purple,
                  ),
                  function: () {
                    MethodUtils.forwardSongMethod(
                        audioGetterProvider, audioSetterProvider);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SongInfoColum extends StatelessWidget {
  const _SongInfoColum({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioGetterProvider = Provider.of<AudioProvider>(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            audioGetterProvider.currentPlayList,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          Text(
            audioGetterProvider.currentSong.name,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          DurationText(
            text: '${TextUtils.changeDurationForm(
              Duration(seconds: audioGetterProvider.songDuration.toInt()),
            )} - ${TextUtils.changeDurationForm(
              Duration(
                seconds: audioGetterProvider.currentSong.duration ~/ 1000,
              ),
            )}',
          ),
        ],
      ),
    );
  }
}
