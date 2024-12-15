import 'package:streamkeys/windows/models/base_action.dart';
import 'package:streamkeys/windows/services/obs_websocket_service.dart';

class UnmuteSource extends BaseAction {
  String sourceName;
  final TextEditingController sourceNameController = TextEditingController();

  static const String actionTypeName = 'UnMute Source';
  static const bool inputMuted = false;

  UnmuteSource({this.sourceName = ''}) : super(actionType: actionTypeName) {
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
  UnmuteSource copy() {
    return UnmuteSource(sourceName: sourceName);
  }

  factory UnmuteSource.fromJson(Json json) {
    return UnmuteSource(
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
