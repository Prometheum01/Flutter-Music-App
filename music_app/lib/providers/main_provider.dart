import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:music_app/extensions/file_extension.dart';
import 'package:music_app/models/song_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MainProvider extends ChangeNotifier {
  bool isManagePermissionGranted = false;
  bool isExternalPermissionGranted = false;

  bool loadingSongs = true;

  bool selectedMode = false;

  bool selectedPlaylistMode = false;

  List songList = [];
  List<SongModel> songModelList = [];
  List<SongModel> allPageList = [];

  List<SongModel> selectedList = [];

  List<Map> selectedPlaylist = [];

  String currentPlaylist = 'all';

  List playlistList = [];

  void selectPlaylistItem(Map playlist) {
    if (!selectedPlaylist.contains(playlist)) {
      selectedPlaylist.add(playlist);
    } else {
      selectedPlaylist.remove(playlist);
      if (selectedPlaylist.isEmpty) {
        changeSelectedPlaylistMode();
      }
    }

    notifyListeners();
  }

  void resetSelectedPlaylistThings() {
    selectedPlaylistMode = false;
    selectedPlaylist = [];
    notifyListeners();
  }

  void removeSelectedPlaylistItem() {
    for (Map pl in selectedPlaylist) {
      playlistList.remove(pl);
    }
    resetSelectedPlaylistThings();
  }

  void selectItem(SongModel songModel) {
    if (!selectedList.contains(songModel)) {
      selectedList.add(songModel);
    } else {
      selectedList.remove(songModel);
      if (selectedList.isEmpty) {
        changeSelectedMode();
      }
    }

    notifyListeners();
  }

  void resetSelectedThings() {
    selectedMode = false;
    selectedList = [];
    notifyListeners();
  }

  void addSelectedItem(List<SongModel> list) {
    for (SongModel songModel in selectedList) {
      if (!list.contains(songModel)) {
        list.add(songModel);
      }
    }
    resetSelectedThings();
  }

  void removeSelectedItem(List<SongModel> list) {
    for (SongModel songModel in selectedList) {
      list.remove(songModel);
    }
    resetSelectedThings();
  }

  getExternalPermission() async {
    if (await Permission.storage.request().isGranted) {
      isExternalPermissionGranted = true;
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      isExternalPermissionGranted = false;
    }
  }

  getManagePermission() async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      isExternalPermissionGranted = true;
    } else if (await Permission.manageExternalStorage
        .request()
        .isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.manageExternalStorage.request().isDenied) {
      isExternalPermissionGranted = false;
    }
  }

  getAllPermissions() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final info = await deviceInfoPlugin.androidInfo;
      if (info.version.sdkInt! >= 30) {
        await getManagePermission();
      }
      getExternalPermission();
    }
  }

  checkAllFiles(String path) {
    Directory directory = Directory(path);

    List<FileSystemEntity> fileList = directory.listSync();

    for (FileSystemEntity file in fileList) {
      FileStat stat = file.statSync();

      if (stat.type == FileSystemEntityType.directory) {
        if ((file.path == '/storage/emulated/0/Android/data') ||
            (file.path == '/storage/emulated/0/Android/obb') ||
            (file.path == '/storage/${file.secondPath}/Android/data') ||
            (file.path == '/storage/${file.secondPath}/Android/obb')) {
          continue;
        }

        checkAllFiles(file.path);
      } else if (stat.type == FileSystemEntityType.file) {
        if (file.isMp3 || file.isM4a) {
          //Add List
          songList.add(file);
          continue;
        } else {
          continue;
        }
      }
    }
  }

  givePathForFunc() async {
    final List<Directory>? directoryies = await getExternalStorageDirectories();

    for (Directory dir in directoryies!) {
      if (dir.secondPath == 'emulated') {
        await checkAllFiles(dir.mainStoragePath);
      } else {
        await checkAllFiles(dir.sdCardStoragePath);
      }
    }

    createSongsModel();
  }

  createSongsModel() async {
    for (FileSystemEntity song in songList) {
      final metadata = await MetadataRetriever.fromFile(
        File(song.path),
      );
      SongModel songModel = SongModel(
          name: song.nameWithoutType,
          path: metadata.filePath ?? song.path,
          album: metadata.albumName ?? 'Unknown',
          artist: metadata.trackArtistNames ?? ['Unknown'],
          image: metadata.albumArt == null
              ? 'assets/images/ic_note.jpg'
              : metadata.albumArt ?? Uint8List(0),
          duration: metadata.trackDuration ?? -1);
      songModelList.add(songModel);
      allPageList.add(songModel);
    }

    songModelList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    allPageList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    notifyListeners();
  }

  loadSongs() async {
    await getAllPermissions();
    await givePathForFunc();
    loadingSongs = false;
    notifyListeners();
  }

  Future<void> addNewPlaylist(Map playlist) async {
    playlistList.add(playlist);
    notifyListeners();
  }

  void changeLoadingSongs() {
    loadingSongs = !loadingSongs;
    notifyListeners();
  }

  void changeSelectedMode() {
    selectedMode = !selectedMode;
    notifyListeners();
  }

  void changeSelectedPlaylistMode() {
    selectedPlaylistMode = !selectedPlaylistMode;
    notifyListeners();
  }
}
