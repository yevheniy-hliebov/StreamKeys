import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TokenInfoTile extends StatelessWidget {
  const TokenInfoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        'Where to get tokens',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: GestureDetector(
        onTap: () async {
          final url = Uri.parse('https://twitchtokengenerator.com');
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          }
        },
        child: const MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Text(
            'https://twitchtokengenerator.com\nEasy token generation for Twitch API',
            style: TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
          ),
        ),
      ),
    );
  }
}
