import 'dart:io';

extension FileExtesion on FileSystemEntity {
  String get nameWithType {
    return path.split('/').last;
  }

  String get secondPath {
    String secondSplit = path.split('/').elementAt(2);
    return secondSplit;
  }

  String get mainStoragePath {
    String firstSplit = path.split('/').elementAt(1);
    String secondSplit = path.split('/').elementAt(2);
    String thirdSplit = path.split('/').elementAt(3);
    return '/$firstSplit/$secondSplit/$thirdSplit/';
  }

  String get sdCardStoragePath {
    String firstSplit = path.split('/').elementAt(1);
    String secondSplit = path.split('/').elementAt(2);
    return '/$firstSplit/$secondSplit/';
  }

  String get nameWithoutType {
    if (isMp3) {
      return nameWithType.replaceRange(nameWithType.length - 4, null, '');
    } else if (isM4a) {
      return nameWithType.replaceRange(nameWithType.length - 4, null, '');
    }

    return nameWithType;
  }

  bool get isMp3 {
    if (nameWithType.endsWith('.mp3')) {
      return true;
    }
    return false;
  }

  bool get isM4a {
    if (nameWithType.endsWith('.m4a')) {
      return true;
    }
    return false;
  }
}
