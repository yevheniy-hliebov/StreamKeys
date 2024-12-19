import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/base_action.dart';
import 'package:streamkeys/windows/services/obs_websocket_service.dart';

class ToogleMuteSource extends BaseAction {
  String sourceName;
  final TextEditingController sourceNameController = TextEditingController();

  static const String actionTypeName = 'Toogle Mute Source';

  ToogleMuteSource({this.sourceName = ''}) : super(actionType: actionTypeName) {
    sourceNameController.text = sourceName;
  }

  @override
  FutureVoid execute({dynamic data}) async {
    if (sourceName.isNotEmpty) {
      final service = data as ObsWebSocketService;
      await service.obs?.inputs.toggleInputMute(sourceName);
    }
  }

  @override
  Json toJson() {
    return {
      'action_type': actionType,
      'source_name': sourceName,
    };
  }

  @override
  void clear() {
    sourceName = '';
    sourceNameController.clear();
  }

  @override
  ToogleMuteSource copy() {
    return ToogleMuteSource(sourceName: sourceName);
  }

  factory ToogleMuteSource.fromJson(Json json) {
    return ToogleMuteSource(
      sourceName: json['source_name'] as String,
    );
  }

  @override
  List<Widget> formFields(BuildContext context) {
    return [
      TextFormField(
        controller: sourceNameController,
        decoration: const InputDecoration(
          labelText: 'Source Name',
        ),
        onChanged: (value) {
          sourceName = value;
        },
      ),
    ];
  }
}
