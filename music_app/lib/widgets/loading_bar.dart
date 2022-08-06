import 'package:flutter/material.dart';

class LoadingBar extends StatelessWidget {
  const LoadingBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
