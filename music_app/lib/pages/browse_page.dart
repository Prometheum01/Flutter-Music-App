import 'package:flutter/material.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/pages/select_song_page.dart';
import 'package:music_app/providers/audio_player_provider.dart';
import 'package:music_app/providers/main_provider.dart';
import 'package:music_app/utils/decoration_utils.dart';
import 'package:music_app/utils/padding_utils.dart';
import 'package:music_app/utils/text_utils.dart';
import 'package:music_app/widgets/browse_bar.dart';
import 'package:music_app/widgets/button_with_material.dart';
import 'package:music_app/widgets/loading_bar.dart';
import 'package:music_app/widgets/playlist_widget.dart';
import 'package:provider/provider.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({Key? key}) : super(key: key);

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mainGetterProvider = Provider.of<MainProvider>(context);

    return Container(
      decoration: DecorationUtils.appBarDecoration,
      child: Scaffold(
        bottomSheet: mainGetterProvider.selectedPlaylistMode
            ? const BottomSheetForBrowsePage()
            : null,
        backgroundColor: Colors.transparent,
        appBar: _appBar(context),
        body: Column(
          children: [
            const BrowseBar(),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    width: double.infinity,
                    decoration: DecorationUtils.browsePageWhiteDecoration,
                    child: Padding(
                      padding: PaddingUtils.topBarPadding,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Playlists',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(color: Colors.purple),
                              ),
                              ButtonWithMaterial(
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.purple,
                                ),
                                function: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AddPlaylistAlert(),
                                  );
                                },
                              ),
                            ],
                          ),
                          mainGetterProvider.loadingSongs
                              ? const LoadingBar()
                              : Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 12,
                                            crossAxisSpacing: 12),
                                    itemCount:
                                        mainGetterProvider.playlistList.length,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return PlaylistWidget(
                                        index: index,
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        TextUtils.browseText.toUpperCase(),
      ),
    );
  }
}

class BottomSheetForBrowsePage extends StatelessWidget {
  const BottomSheetForBrowsePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioGetterProvider = Provider.of<AudioProvider>(context);
    final audioSetterProvider =
        Provider.of<AudioProvider>(context, listen: false);
    final mainSetterProvider =
        Provider.of<MainProvider>(context, listen: false);
    return Container(
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(primary: Colors.purple),
              onPressed: () {
                mainSetterProvider.resetSelectedPlaylistThings();
              },
              child: Text(TextUtils.closeText),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(primary: Colors.purple),
              onPressed: () {
                mainSetterProvider.removeSelectedPlaylistItem();
                audioSetterProvider.changeSongModelList(
                    audioGetterProvider.allPageSongList, 'all');
              },
              child: Text(TextUtils.removeText),
            ),
          ),
        ],
      ),
    );
  }
}

class AddPlaylistAlert extends StatelessWidget {
  AddPlaylistAlert({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          TextUtils.enterNewPlaylistName,
          style: Theme.of(context).textTheme.headline6?.copyWith(fontSize: 22),
        ),
      ),
      content: Form(
        key: formKey,
        child: TextFormField(
          maxLength: 24,
          controller: titleController,
          style: Theme.of(context).textTheme.headline6,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.purple.withOpacity(0.25), width: 2),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.purple, width: 2),
            ),
          ),
          validator: (value) {
            if (value?.trim().isEmpty ?? true) {
              return TextUtils.pleaseEnterNewPlaylistName;
            }
            return null;
          },
        ),
      ),
      shape: DecorationUtils.alertDialogShape,
      actions: [
        SizedBox(
          width: double.infinity,
          child: TextButton(
            style: TextButton.styleFrom(primary: Colors.purple),
            onPressed: () async {
              if (!formKey.currentState!.validate()) {
              } else {
                final mainSetterProvider =
                    Provider.of<MainProvider>(context, listen: false);
                String title = titleController.text;

                Map playlist = {'title': title, 'list': <SongModel>[]};

                mainSetterProvider.addNewPlaylist(playlist);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectSongPage(playlist: playlist),
                  ),
                );
              }
            },
            child: Text(TextUtils.createText),
          ),
        ),
      ],
    );
  }
}
