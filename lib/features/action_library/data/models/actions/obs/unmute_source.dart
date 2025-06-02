import 'package:flutter/material.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/action_library/data/models/base_action.dart';

class UnMuteSource extends BaseAction {
  String sourceName;
  final TextEditingController sourceNameController = TextEditingController();

  static const String actionTypeName = 'unmute_source';
  static const bool inputMuted = false;

  UnMuteSource({this.sourceName = ''})
      : super(
          actionType: actionTypeName,
          dialogTitle: 'Enter a source name',
        ) {
    sourceNameController.text = sourceName;
  }

  @override
  String actionLabel = 'Unmute Source';

  @override
  String get actionName {
    if (sourceName.isEmpty) {
      return 'OBS $actionLabel';
    } else {
      return 'OBS $actionLabel ($sourceName)';
    }
  }

  @override
  FutureVoid execute({dynamic data}) async {
    if (sourceName.isNotEmpty) {
      final obs = data as ObsWebSocket?;
      await obs?.inputs.setInputMute(
        inputName: sourceName,
        inputMuted: inputMuted,
      );
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
  UnMuteSource copy() {
    return UnMuteSource(sourceName: sourceName);
  }

  factory UnMuteSource.fromJson(Json json) {
    return UnMuteSource(
      sourceName: json['source_name'] as String,
    );
  }

  @override
  Widget? form(BuildContext context) {
    return TextFormField(
      controller: sourceNameController,
      decoration: const InputDecoration(
        labelText: 'Source Name',
      ),
      onChanged: (value) {
        sourceName = value;
      },
    );
  }

  @override
  void save() {
    sourceName = sourceNameController.text;
  }

  @override
  void cancel() {
    sourceNameController.text = sourceName;
  }
}
