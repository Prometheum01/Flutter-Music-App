import 'package:flutter/material.dart';
import 'package:music_app/providers/audio_player_provider.dart';
import 'package:music_app/utils/decoration_utils.dart';
import 'package:music_app/utils/text_utils.dart';
import 'package:music_app/widgets/duration_text.dart';
import 'package:music_app/widgets/now_playing_page_buttons_row.dart';
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
    final audioGetterProvider = Provider.of<AudioProvider>(context);
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                PlaylistImage(
                  songList: [audioGetterProvider.currentSong],
                  sizeMultiplier: 0.25,
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 8,
                  ),
                  child: _SongNameText(),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: _AlbumText(),
                ),
                const SongSlider(),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: _DurationTextWithFull(),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: NowPlayingPageButtonsRow(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        TextUtils.nowPlayingText.toUpperCase(),
      ),
    );
  }
}

class _SongNameText extends StatelessWidget {
  const _SongNameText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioGetterProvider = Provider.of<AudioProvider>(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Center(
        child: Text(
          audioGetterProvider.currentSong.name,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 20),
        ),
      ),
    );
  }
}

class _AlbumText extends StatelessWidget {
  const _AlbumText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioGetterProvider = Provider.of<AudioProvider>(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Text(audioGetterProvider.currentSong.album,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2?.copyWith(fontSize: 18)),
    );
  }
}

class _DurationTextWithFull extends StatelessWidget {
  const _DurationTextWithFull({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioGetterProvider = Provider.of<AudioProvider>(context);
    return Row(
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
              seconds: audioGetterProvider.currentSong.duration ~/ 1000,
            ),
          ),
        ),
      ],
    );
  }
}
