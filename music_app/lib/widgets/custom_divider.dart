import 'package:flutter/material.dart';

class CustomDividerForSongBuilder extends StatelessWidget {
  const CustomDividerForSongBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 10,
      indent: 16,
      endIndent: 32,
      color: Colors.black12,
      thickness: 1,
    );
  }
}
