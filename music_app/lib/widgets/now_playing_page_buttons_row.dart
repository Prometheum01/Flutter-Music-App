import 'package:flutter/material.dart';
import 'package:music_app/providers/audio_player_provider.dart';
import 'package:music_app/utils/method_utils.dart';
import 'package:music_app/widgets/button_with_material.dart';
import 'package:provider/provider.dart';

enum ReleaseSituation {
  off,
  single,
  multi,
}

class NowPlayingPageButtonsRow extends StatefulWidget {
  const NowPlayingPageButtonsRow({Key? key}) : super(key: key);

  @override
  State<NowPlayingPageButtonsRow> createState() =>
      _NowPlayingPageButtonsRowState();
}

class _NowPlayingPageButtonsRowState extends State<NowPlayingPageButtonsRow> {
  IconData releaseIcon = Icons.replay_outlined;

  IconData getReleaseIconData() {
    AudioProvider audioGetterProvider = Provider.of<AudioProvider>(
      context,
    );

    switch (audioGetterProvider.releaseMode) {
      case ReleaseSituation.off:
        releaseIcon = Icons.replay_outlined;
        break;
      case ReleaseSituation.single:
        releaseIcon = Icons.replay_circle_filled_outlined;
        break;
      case ReleaseSituation.multi:
        releaseIcon = Icons.reply_all_outlined;
        break;
      default:
        releaseIcon = Icons.replay_outlined;
    }
    setState(() {});
    return releaseIcon;
  }

  @override
  Widget build(BuildContext context) {
    AudioProvider audioGetterProvider = Provider.of<AudioProvider>(
      context,
    );
    final audioSetterProvider = Provider.of<AudioProvider>(
      context,
      listen: false,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ButtonWithMaterial(
          icon: Icon(audioGetterProvider.shuffleMode
              ? Icons.shuffle_on_outlined
              : Icons.shuffle_outlined),
          function: () {
            audioSetterProvider.changeShuffleMode();
          },
        ),
        ButtonWithMaterial(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
          ),
          function: () {
            if (audioGetterProvider.currenctSoundPath != '') {
              MethodUtils.backSongMethod(
                  audioGetterProvider, audioSetterProvider);
            }
          },
        ),
        CircleAvatar(
          backgroundColor: Colors.purple,
          radius: 24,
          child: IconButton(
            onPressed: () {
              if (audioGetterProvider.currenctSoundPath != '') {
                if (audioGetterProvider.isPlaySound) {
                  //pause
                  audioSetterProvider.pauseSong();
                } else {
                  //resume
                  audioSetterProvider.resumeSong();
                }
              }
            },
            icon: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                color: Colors.white,
                size: 24,
                progress: audioGetterProvider.animationController),
          ),
        ),
        ButtonWithMaterial(
          icon: const Icon(
            Icons.arrow_forward_ios_outlined,
          ),
          function: () {
            if (audioGetterProvider.currenctSoundPath != '') {
              MethodUtils.forwardSongMethod(
                  audioGetterProvider, audioSetterProvider);
            }
          },
        ),
        ButtonWithMaterial(
          icon: Icon(
            getReleaseIconData(),
          ),
          function: () {
            audioSetterProvider.changeReleaseMode();
          },
        ),
      ],
    );
  }
}
