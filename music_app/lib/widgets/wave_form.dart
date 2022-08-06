import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_app/providers/audio_player_provider.dart';
import 'package:music_app/utils/decoration_utils.dart';

class WaveFormForSong extends StatefulWidget {
  const WaveFormForSong({
    Key? key,
    required this.audioGetterProvider,
  }) : super(key: key);

  final AudioProvider audioGetterProvider;

  @override
  State<WaveFormForSong> createState() => _WaveFormForSongState();
}

class _WaveFormForSongState extends State<WaveFormForSong> {
  double createRandomDouble() {
    return Random().nextDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        waveBar(context),
        waveBar(context),
        waveBar(context),
        waveBar(context),
        waveBar(context),
      ],
    );
  }

  waveBar(BuildContext context) {
    double value = MediaQuery.of(context).size.height * 0.05;
    return Container(
      height: value * createRandomDouble(),
      width: MediaQuery.of(context).size.width * 0.015,
      decoration: DecorationUtils.waveDecoration,
    );
  }
}
