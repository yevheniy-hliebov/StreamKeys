import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormIpAddressDialog extends StatefulWidget {
  final String? lastOctet;
  final void Function(String newLastOctet)? onPressed;

  const FormIpAddressDialog({
    super.key,
    this.lastOctet = '',
    this.onPressed,
  });

  @override
  State<FormIpAddressDialog> createState() => _FormIpAddressDialogState();
}

class _FormIpAddressDialogState extends State<FormIpAddressDialog> {
  late TextEditingController lastOctetController;

  @override
  void initState() {
    super.initState();
    lastOctetController = TextEditingController(text: widget.lastOctet ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update host IPv4'),
      content: SingleChildScrollView(
        child: TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF2F2F2F),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            labelText: 'Last octet',
            prefixText: '192.168.1.',
          ),
          controller: lastOctetController,
        ),
      ),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('lastOctet', lastOctetController.text);
            widget.onPressed?.call(lastOctetController.text);
          },
          child: const Text(
            'Save',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
