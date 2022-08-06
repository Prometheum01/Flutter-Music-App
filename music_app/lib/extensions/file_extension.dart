import 'dart:io';

extension FileExtesion on FileSystemEntity {
  String get nameWithType {
    return path.split('/').last;
  }

  String get secondPath {
    String a = path.split('/').elementAt(2);
    return a;
  }

  String get mainStoragePath {
    String a = path.split('/').elementAt(1);
    String b = path.split('/').elementAt(2);
    String c = path.split('/').elementAt(3);
    return '/$a/$b/$c/';
  }

  String get sdCardStoragePath {
    String a = path.split('/').elementAt(1);
    String b = path.split('/').elementAt(2);
    return '/$a/$b/';
  }

  String get nameWithoutType {
    //abc.mp3
    //0123456
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
