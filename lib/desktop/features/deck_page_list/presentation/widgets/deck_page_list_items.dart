import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/typography.dart';

class DeckPageListItems extends StatelessWidget {
  const DeckPageListItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        ListTile(
          title: Text(
            'Default page',
            style: AppTypography.body,
          ),
        ),
        ListTile(
          title: Text(
            'Page',
            style: AppTypography.body,
          ),
        ),
        ListTile(
          title: Text(
            'Page 1',
            style: AppTypography.body,
          ),
        ),
      ],
    );
  }
}
