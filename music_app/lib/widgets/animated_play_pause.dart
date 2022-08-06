import 'package:flutter/material.dart';
import 'package:music_app/providers/audio_player_provider.dart';
import 'package:provider/provider.dart';

class AnimatedPlayPauseButton extends StatelessWidget {
  const AnimatedPlayPauseButton({
    Key? key,
    required this.path,
  }) : super(key: key);

  final String path;

  @override
  Widget build(BuildContext context) {
    final audioGetterProvider = Provider.of<AudioProvider>(context);
    final audioSetterProvider =
        Provider.of<AudioProvider>(context, listen: false);

    return IconButton(
      onPressed: () async {
        if (audioGetterProvider.currenctSoundPath != '') {
          if (!audioGetterProvider.isPlaySound) {
            audioSetterProvider.resumeSong();
          } else {
            audioSetterProvider.pauseSong();
          }
        }
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.play_pause,
        color: Colors.purple,
        progress: audioGetterProvider.animationController,
      ),
    );
  }
}
