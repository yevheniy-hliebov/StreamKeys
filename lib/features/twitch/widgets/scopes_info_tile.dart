import 'package:flutter/material.dart';

class ScopesInfoTile extends StatelessWidget {
  const ScopesInfoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      title: Text(
        'Required scopes',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• user:write:chat — allows sending messages to chat'),
        ],
      ),
    );
  }
}
