import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkeys/android/android_home_page.dart';

class LastOctetPage extends StatefulWidget {
  final bool isFirstPage;
  final int? lastOctet;

  const LastOctetPage({
    super.key,
    this.isFirstPage = true,
    this.lastOctet,
  });

  @override
  State<LastOctetPage> createState() => _LastOctetPageState();
}

class _LastOctetPageState extends State<LastOctetPage> {
  late TextEditingController lastOctetController;

  @override
  void initState() {
    super.initState();
    lastOctetController = TextEditingController(
      text: widget.lastOctet != null ? widget.lastOctet.toString() : '',
    );
  }

  Future<void> onSave(BuildContext context) async {
    if (lastOctetController.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastOctet', lastOctetController.text);
      if (widget.isFirstPage && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AndroidHomePage(
              lastOctet: int.parse(lastOctetController.text),
            ),
          ),
        );
      } else if (context.mounted) {
        Navigator.of(context).pop(int.parse(lastOctetController.text));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildScaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
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
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () async => onSave(context),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildScaffold({required Widget body}) {
    if (widget.isFirstPage) {
      return Scaffold(
        body: body,
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(lastOctetController.text);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: body,
      );
    }
  }
}
