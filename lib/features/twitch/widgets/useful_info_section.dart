import 'package:flutter/material.dart';
import 'package:streamkeys/features/twitch/widgets/scopes_info_tile.dart';
import 'package:streamkeys/features/twitch/widgets/token_info_tile.dart';

class UsefulInfoSection extends StatelessWidget {
  const UsefulInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      constraints: const BoxConstraints(maxWidth: 816),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: const ExpansionTile(
        title: Text(
          'Useful Information',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          TokenInfoTile(),
          ScopesInfoTile(),
        ],
      ),
    );
  }
}
