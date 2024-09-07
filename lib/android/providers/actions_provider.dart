import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkeys/android/models/action.dart';
import 'package:streamkeys/android/providers/loading_provider.dart';
import 'package:streamkeys/android/services/action_request_service.dart';
import 'package:streamkeys/android/widgets/form_ip_address_dialog.dart';

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
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return FormIpAddressDialog(
          lastOctet: lastOctet,
          onPressed: (newLastOctet) async {
            actionRequestService.lastOctet = newLastOctet;
            await getActions();
          },
        );
      },
    );
  }
}
