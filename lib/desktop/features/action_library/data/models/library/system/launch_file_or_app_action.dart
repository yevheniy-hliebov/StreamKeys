import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/typedef.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/action_registry.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_icons.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/forms/launch_file_or_app_action_form.dart';
import 'package:streamkeys/service_locator.dart';
import 'package:uuid/uuid.dart';

class LaunchFileOrAppAction extends BindingAction {
  final String filePath;
  final bool launchAsAdmin;

  LaunchFileOrAppAction({
    String? id,
    this.filePath = '',
    this.launchAsAdmin = false,
  }) : super(
          id: id ?? const Uuid().v4(),
          type: ActionTypes.launcFileOrApp,
          name: 'Launch file or app',
        );

  @override
  String get dialogTitle => 'Enter the file path';

  @override
  String get label {
    if (filePath.isEmpty) {
      return name;
    } else {
      return '$name ($filePath${launchAsAdmin ? ', as admin' : ''})';
    }
  }

  @override
  Widget getIcon(BuildContext context) {
    return BindingActionIcons.of(context).launcFileOrApp;
  }

  @override
  Json toJson() {
    return {
      'type': type,
      'file_path': filePath,
      'launch_as_admin': launchAsAdmin,
    };
  }

  factory LaunchFileOrAppAction.fromJson(Json json) {
    return LaunchFileOrAppAction(
      filePath: json['file_path'] as String,
      launchAsAdmin: json['launch_as_admin'] as bool? ?? false,
    );
  }

  @override
  BindingAction copy() {
    return LaunchFileOrAppAction(
      filePath: filePath,
      launchAsAdmin: launchAsAdmin,
    );
  }

  @override
  Future<void> execute({Object? data}) async {
    if (filePath.isNotEmpty) {
      await sl<LaunchFileOrAppService>()
          .launch(filePath, asAdmin: launchAsAdmin);
    }
  }

  @override
  Widget? form(
    BuildContext context, {
    void Function(BindingAction updatedAction)? onUpdate,
  }) {
    return LaunchFileOrAppActionForm(
      initialAction: this,
      onUpdate: (newValue) {
        onUpdate?.call(newValue);
      },
    );
  }

  @override
  List<Object?> get props => [id, type, name, filePath, launchAsAdmin];
}
