class TextUtils {
  //BROWSE PAGE
  static const String browseText = 'Browse';
  static const String searchHintText = 'Search For Song, Artist...';
  static const String playListsText = 'Playlists';

  //MUSIC PLAYER PAGE
  static const String musicPlayerText = 'Music Player';
  static const String playListText = 'Playlist Overview';

  //All SONGS PAGE
  static const String allSongsText = 'All Songs';

  //NOW PLAYING PAGE
  static const String nowPlayingText = 'Now Playing';

  static String changeDurationForm(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(
      duration.inMinutes.remainder(60),
    );
    final seconds = twoDigits(
      duration.inSeconds.remainder(60),
    );

    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  static String closeText = 'Close';
  static String removeText = 'Remove';
  static String createText = 'Create';
  static String addText = 'Add for playlist';
  static String enterNewPlaylistName = 'Enter playlist name';
  static String pleaseEnterNewPlaylistName = 'Please enter playlist name!';
}
