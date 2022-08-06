import 'package:flutter/material.dart';
import 'package:music_app/providers/audio_player_provider.dart';
import 'package:music_app/utils/decoration_utils.dart';
import 'package:music_app/utils/method_utils.dart';
import 'package:music_app/utils/text_utils.dart';
import 'package:music_app/widgets/button_with_material.dart';
import 'package:music_app/widgets/duration_text.dart';
import 'package:music_app/widgets/playlist_widget.dart';
import 'package:music_app/widgets/song_slider.dart';
import 'package:provider/provider.dart';

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({Key? key}) : super(key: key);

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final audioGetterProvider = Provider.of<AudioProvider>(
      context,
    );
    final audioSetterProvider =
        Provider.of<AudioProvider>(context, listen: false);

    IconData releaseIcon = Icons.replay_outlined;

    IconData getReleaseIconData() {
      String releaseMode = audioGetterProvider.releaseMode;

      switch (releaseMode) {
        case 'off':
          releaseIcon = Icons.replay_outlined;
          break;
        case 'single':
          releaseIcon = Icons.replay_circle_filled_outlined;
          break;
        case 'multi':
          releaseIcon = Icons.reply_all_outlined;
          break;
        default:
          releaseIcon = Icons.replay_outlined;
      }
      setState(() {});
      return releaseIcon;
    }

    return Container(
      decoration: DecorationUtils.appBarDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _appBar(context),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                PlaylistImage(
                  songList: [audioGetterProvider.currentSong],
                  sizeMultiplier: 0.3,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Center(
                      child: Text(
                        audioGetterProvider.currentSong.name,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Text(
                      audioGetterProvider.currentSong.album,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.25),
                          ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 32),
                  child: SongSlider(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DurationText(
                        text: TextUtils.changeDurationForm(
                          Duration(seconds: audioGetterProvider.songDuration),
                        ),
                      ),
                      DurationText(
                        text: TextUtils.changeDurationForm(
                          Duration(
                            seconds: audioGetterProvider.currentSong.duration ~/
                                1000,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        icon:
                            const Icon(Icons.arrow_back_ios_outlined, size: 30),
                        function: () {
                          if (audioGetterProvider.currenctSoundPath != '') {
                            MethodUtils.backSongMethod(
                                audioGetterProvider, audioSetterProvider);
                          }
                        },
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.purple,
                        radius: 36,
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
                              size: 36,
                              progress:
                                  audioGetterProvider.animationController),
                        ),
                      ),
                      ButtonWithMaterial(
                        icon: const Icon(Icons.arrow_forward_ios_outlined,
                            size: 30),
                        function: () {
                          if (audioGetterProvider.currenctSoundPath != '') {
                            MethodUtils.forwardSongMethod(
                                audioGetterProvider, audioSetterProvider);
                          }
                        },
                      ),
                      ButtonWithMaterial(
                        icon: Icon(getReleaseIconData()),
                        function: () {
                          audioSetterProvider.changeReleaseMode();
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        TextUtils.nowPlayingText.toUpperCase(),
        style: Theme.of(context)
            .textTheme
            .headline5
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }
}
