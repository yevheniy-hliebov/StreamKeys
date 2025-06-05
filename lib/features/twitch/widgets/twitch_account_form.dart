import 'package:flutter/material.dart';
import 'package:streamkeys/features/twitch/data/models/twich_account.dart';

class TwitchAccountForm extends StatefulWidget {
  final String label;
  final void Function(TwitchAccount account) onSave;
  final TwitchAccount? initialAccount;
  final bool isSaving;

  const TwitchAccountForm({
    super.key,
    required this.label,
    required this.onSave,
    this.initialAccount,
    this.isSaving = false,
  });

  @override
  State<TwitchAccountForm> createState() => _TwitchAccountFormState();
}

class _TwitchAccountFormState extends State<TwitchAccountForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _username;
  late final TextEditingController _accessToken;
  late final TextEditingController _refreshToken;
  late final TextEditingController _clientId;

  @override
  void initState() {
    super.initState();
    _username =
        TextEditingController(text: widget.initialAccount?.username ?? '');
    _accessToken =
        TextEditingController(text: widget.initialAccount?.accessToken ?? '');
    _refreshToken =
        TextEditingController(text: widget.initialAccount?.refreshToken ?? '');
    _clientId =
        TextEditingController(text: widget.initialAccount?.clientId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextFormField(
              controller: _username,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextFormField(
              controller: _accessToken,
              decoration: const InputDecoration(labelText: 'Access Token'),
              obscureText: true,
            ),
            TextFormField(
              controller: _refreshToken,
              decoration: const InputDecoration(labelText: 'Refresh Token'),
              obscureText: true,
            ),
            TextFormField(
              controller: _clientId,
              decoration: const InputDecoration(labelText: 'Client ID'),
              obscureText: true,
            ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: widget.isSaving
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              widget.onSave(TwitchAccount(
                                username: _username.text,
                                accessToken: _accessToken.text,
                                refreshToken: _refreshToken.text,
                                clientId: _clientId.text,
                              ));
                            }
                          },
                    child: Text(widget.isSaving ? 'Saving...' : 'Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
