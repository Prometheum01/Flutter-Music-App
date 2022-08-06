import 'package:flutter/material.dart';

class ButtonWithMaterial extends StatelessWidget {
  const ButtonWithMaterial({
    Key? key,
    required this.icon,
    required this.function,
  }) : super(key: key);

  final Icon icon;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(360)),
        onTap: () {
          function();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: icon,
        ),
      ),
    );
  }
}
