import 'package:flutter/material.dart';
import 'package:music_app/utils/color_utils.dart';
import 'package:music_app/utils/text_utils.dart';

class DecorationUtils {
  static const browsePageWhiteDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(32),
    ),
  );

  static const allSongsPageWhiteDecoration = BoxDecoration(
    color: Colors.white,
  );

  static const browseBarDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(
      Radius.circular(360),
    ),
  );

  static const browseBarTextFieldDecoration = InputDecoration(
    hintText: TextUtils.searchHintText,
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
    ),
  );

  static const appBarDecoration =
      BoxDecoration(gradient: ColorUtils.gradientAppBar);

  static const alertDialogShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(24),
    ),
  );

  static const nowPlayingContainerBoxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(
      Radius.circular(36),
    ),
  );

  static const waveDecoration = BoxDecoration(
    color: Colors.purple,
    borderRadius: BorderRadius.all(
      Radius.circular(360),
    ),
  );
}
