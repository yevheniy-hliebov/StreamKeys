import 'package:flutter/material.dart';
import 'package:streamkeys/windows/providers/obs_connection_provider.dart';

class ObsConnectionForm extends StatelessWidget {
  final ObsConnectionProvider provider;

  const ObsConnectionForm({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Form(
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  'OBS Connection',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: provider.urlController,
              decoration: const InputDecoration(
                labelText: 'Host',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: provider.passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () async {
                await provider.connect(provider.obsConnectionData);
              },
              child: const Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }
}
