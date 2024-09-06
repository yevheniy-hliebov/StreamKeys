import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkeys/android/models/action.dart';
import 'package:streamkeys/android/providers/loading_provider.dart';
import 'package:streamkeys/android/services/action_request_service.dart';

class ActionsProvider extends LoadingProvider {
  ActionRequestService actionRequestService = ActionRequestService();
  List<ButtonAction> actions = [];

  int get actionsLength => actions.length;

  ActionsProvider(BuildContext context) {
    init(context);
  }

  Future<void> init(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final lastOctet = prefs.getString('lastOctet');

    print("lastOctet: $lastOctet");

    if ((lastOctet == null || lastOctet == '') && context.mounted) {
      await showMyDialog(context, lastOctet: actionRequestService.lastOctet);
    } else {
      actionRequestService.lastOctet = lastOctet!;
      await getActions();
    }
  }

  Future<void> getActions() async {
    startLoading();
    try {
      actions = await actionRequestService.getActions();
    } catch (e) {
      actions = [];
    }
    stopLoading();
  }

  Future<void> clickAction(int id) async {
    HapticFeedback.vibrate();
    await actionRequestService.clickAction(id);
  }

  String getImageUrl(int id) {
    return "${actionRequestService.url}/$id/image";
  }

  Future<void> updateLastOctet(BuildContext context) async {
    await showMyDialog(context, lastOctet: actionRequestService.lastOctet);
  }

  Future<void> showMyDialog(BuildContext context, {String? lastOctet}) async {
    TextEditingController lastOctetController =
        TextEditingController(text: lastOctet ?? '');

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
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
                actionRequestService.lastOctet = lastOctetController.text;
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('lastOctet', lastOctetController.text);
                await getActions();
              },
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }
}
