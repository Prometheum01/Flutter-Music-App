import 'package:flutter/material.dart';
import 'package:music_app/providers/audio_player_provider.dart';
import 'package:music_app/providers/main_provider.dart';
import 'package:music_app/utils/decoration_utils.dart';
import 'package:music_app/utils/padding_utils.dart';
import 'package:music_app/utils/text_utils.dart';
import 'package:music_app/widgets/custom_divider.dart';
import 'package:music_app/widgets/loading_bar.dart';
import 'package:music_app/widgets/now_playing_container.dart';
import 'package:music_app/widgets/selected_bottom_sheet.dart';
import 'package:music_app/widgets/song_list_tile.dart';
import 'package:provider/provider.dart';

class AllSongsPage extends StatefulWidget {
  const AllSongsPage({Key? key}) : super(key: key);

  @override
  State<AllSongsPage> createState() => _AllSongsPageState();
}

class _AllSongsPageState extends State<AllSongsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    final provider = Provider.of<AudioProvider>(context, listen: false);
    final mainSetterProvider =
        Provider.of<MainProvider>(context, listen: false);

    provider.setAnimationController(_animationController);
    mainSetterProvider.selectedMode = false;
    mainSetterProvider.selectedList = [];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);
    final audioGetterProvider =
        Provider.of<AudioProvider>(context, listen: false);

    return Container(
      decoration: DecorationUtils.appBarDecoration,
      child: Scaffold(
        bottomSheet: provider.selectedMode
            ? SelectedBottomSheet(
                songList: audioGetterProvider.allPageSongList,
                secondItemType: 1,
              )
            : null,
        appBar: _appBar(context),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const Padding(
              padding: PaddingUtils.allPageSongMainPadding,
              child: NowPlayingContainer(),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  decoration: DecorationUtils.allSongsPageWhiteDecoration,
                  child: provider.loadingSongs
                      ? const LoadingBar()
                      : ListView.separated(
                          separatorBuilder: (context, index) =>
                              const CustomDividerForSongBuilder(),
                          physics: const BouncingScrollPhysics(),
                          itemCount: audioGetterProvider.allPageSongList.length,
                          itemBuilder: (context, index) => SongListTile(
                            index: index,
                            allSongList: audioGetterProvider.allPageSongList,
                            title: 'all',
                          ),
                        ),
                ),
              ),
            ),
          ],
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
        TextUtils.allSongsText.toUpperCase(),
        style: Theme.of(context)
            .textTheme
            .headline5
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }
}
