class SongModel {
  String name;
  String path;
  String album;
  List<String> artist;
  int duration;
  dynamic image;

  SongModel({
    required this.name,
    required this.path,
    required this.album,
    required this.artist,
    required this.image,
    required this.duration,
  });
}
