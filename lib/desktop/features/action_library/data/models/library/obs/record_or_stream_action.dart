import 'package:flutter/cupertino.dart';
import 'package:streamkeys/common/models/typedef.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/action_registry.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_icons.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/action_state_enum.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/forms/record_or_stream_action_form.dart';
import 'package:streamkeys/service_locator.dart';
import 'package:uuid/uuid.dart';

class RecordOrStreamAction extends BindingAction {
  final ProcessState state;

  RecordOrStreamAction({
    String? id,
    required super.type,
    this.state = ProcessState.start,
  }) : super(
         id: id ?? const Uuid().v4(),
         name: type == ActionTypes.obsRecord ? 'Record' : 'Stream',
       );

  @override
  String get dialogTitle => 'Set $name State';

  @override
  String get label {
    return 'OBS | ${state.nameString} $name';
  }

  @override
  Widget getIcon(BuildContext context) {
    if (type == ActionTypes.obsRecord) {
      return BindingActionIcons.of(context).obsRecord;
    }
    return BindingActionIcons.of(context).obsStream;
  }

  @override
  Json toJson() {
    return {'type': type, 'state': state.name};
  }

  factory RecordOrStreamAction.fromJson(Json json) {
    return RecordOrStreamAction(
      type: json['type'] as String,
      state: ProcessState.fromString(json['state'] as String),
    );
  }

  @override
  BindingAction copy() {
    return RecordOrStreamAction(type: type, state: state);
  }

  @override
  Future<void> execute({Object? data}) async {
    final obs = sl<ObsService>().obs;

    if (obs == null) return;

    if (type == ActionTypes.obsRecord) {
      if (state.isStart) {
        await obs.record.startRecord();
      } else if (state.isStop) {
        await obs.record.stopRecord();
      } else {
        await obs.record.toggleRecord();
      }
    } else if (type == ActionTypes.obsStream) {
      if (state.isStart) {
        await obs.stream.startStream();
      } else if (state.isStop) {
        await obs.stream.stopStream();
      } else {
        await obs.stream.toggleStream();
      }
    }
  }

  @override
  Widget? form(
    BuildContext context, {
    void Function(BindingAction updatedAction)? onUpdated,
  }) {
    return RecordOrStreamActionForm(
      initialState: state,
      onUpdated: (updated) {
        onUpdated?.call(RecordOrStreamAction(type: type, state: updated));
      },
    );
  }

  @override
  List<Object?> get props => [id, type, name, state];
}
