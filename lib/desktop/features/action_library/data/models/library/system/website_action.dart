import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/typedef.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/action_registry.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_icons.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/forms/single_field_binding_action_form.dart';
import 'package:streamkeys/desktop/utils/url_launcher.dart';
import 'package:uuid/uuid.dart';

class WebsiteAction extends BindingAction {
  final String url;
  final UrlLauncher? urlLauncher;

  WebsiteAction({String? id, this.urlLauncher, this.url = ''})
      : super(
          id: id ?? const Uuid().v4(),
          type: ActionTypes.website,
          name: 'Open website',
        );

  @override
  String get dialogTitle => 'Enter the website URL';

  @override
  String get label {
    if (url.isEmpty) {
      return name;
    } else {
      return '$name ($url)';
    }
  }

  @override
  Widget getIcon(BuildContext context) {
    return BindingActionIcons.of(context).website;
  }

  @override
  Json toJson() {
    return {
      'type': type,
      'url': url,
    };
  }

  factory WebsiteAction.fromJson(Json json) {
    return WebsiteAction(
      url: json['url'] as String,
    );
  }

  @override
  BindingAction copy() {
    return WebsiteAction(url: url);
  }

  @override
  Future<void> execute({Object? data}) async {
    final urlLauncher = this.urlLauncher ?? UrlLauncher();

    if (url.isNotEmpty) {
      final Uri uri = Uri.parse(url);

      if (await urlLauncher.canLaunchUrl(uri)) {
        await urlLauncher.launchUrl(uri);
      }
    }
  }

  @override
  Widget? form(
    BuildContext context, {
    void Function(BindingAction updatedAction)? onUpdated,
  }) {
    return SingleFieldBindingActionForm(
      label: 'Url',
      initialValue: url,
      onUpdate: (newValue) {
        onUpdated?.call(WebsiteAction(url: newValue));
      },
    );
  }

  @override
  List<Object?> get props => [id, type, name, url];
}
