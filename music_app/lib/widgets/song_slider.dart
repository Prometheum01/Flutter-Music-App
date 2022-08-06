import 'package:flutter/material.dart';
import 'package:music_app/providers/audio_player_provider.dart';
import 'package:provider/provider.dart';

class SongSlider extends StatelessWidget {
  const SongSlider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioProvider audioGetterProvider =
        Provider.of<AudioProvider>(context);
    final AudioProvider audioSetterProvider =
        Provider.of<AudioProvider>(context, listen: false);
    return SliderTheme(
      data: SliderTheme.of(context)
          .copyWith(thumbShape: SliderComponentShape.noThumb, trackHeight: 8),
      child: Slider(
        min: 0.0,
        max: audioGetterProvider.currentSong.duration / 1000,
        value: audioGetterProvider.songDuration.toDouble(),
        activeColor: Colors.purple,
        inactiveColor: Colors.purple.shade50,
        onChanged: (value) async {
          final position = Duration(seconds: value.toInt());
          audioSetterProvider.changePosition(position);
        },
      ),
    );
  }
}
