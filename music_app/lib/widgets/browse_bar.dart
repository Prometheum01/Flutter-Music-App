import 'package:flutter/material.dart';
import 'package:music_app/utils/decoration_utils.dart';
import 'package:music_app/utils/padding_utils.dart';

class BrowseBar extends StatelessWidget {
  const BrowseBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      width: double.infinity,
      child: Padding(
        padding: PaddingUtils.browseBarPadding,
        child: Ink(
          decoration: DecorationUtils.browseBarDecoration,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: PaddingUtils.browseTextFieldPadding,
                  child: TextFormField(
                    decoration: DecorationUtils.browseBarTextFieldDecoration,
                  ),
                ),
              ),
              IconButton(
                splashRadius: 24,
                onPressed: () {},
                icon: const Icon(Icons.search_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
