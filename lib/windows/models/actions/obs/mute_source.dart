import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/base_action.dart';
import 'package:streamkeys/windows/services/obs_websocket_service.dart';

class MuteSource extends BaseAction {
  String sourceName;
  final TextEditingController sourceNameController = TextEditingController();

  static const String actionTypeName = 'Mute Source';
  static const bool inputMuted = true;

  MuteSource({this.sourceName = ''}) : super(actionType: actionTypeName) {
    sourceNameController.text = sourceName;
  }

  @override
  FutureVoid execute({dynamic data}) async {
    if (sourceName.isNotEmpty) {
      final service = data as ObsWebSocketService;
      await service.obs?.inputs.setInputMute(inputName: sourceName, inputMuted: inputMuted);
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
  MuteSource copy() {
    return MuteSource(sourceName: sourceName);
  }

  factory MuteSource.fromJson(Json json) {
    return MuteSource(
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
