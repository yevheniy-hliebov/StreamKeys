import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/typedef.dart';
import 'package:streamkeys/common/widgets/field_label.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/action_registry.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class WebsiteBindingAction extends BindingAction {
  String url;
  late TextEditingController urlController;

  WebsiteBindingAction({this.url = ''})
      : super(type: ActionTypes.website, name: 'Open website') {
    urlController = TextEditingController(text: url);
  }

  @override
  String dialogTitle = 'Enter the website URL';

  @override
  String get actionLabel {
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

  factory WebsiteBindingAction.fromJson(Json json) {
    return WebsiteBindingAction(
      url: json['url'] as String,
    );
  }

  @override
  BindingAction copyWith() {
    return WebsiteBindingAction(url: url);
  }

  @override
  Future<void> execute({Object? data}) async {
    if (url.isNotEmpty) {
      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }

  @override
  Widget? form(BuildContext context) {
    return Column(
      spacing: Spacing.xs,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('Url'),
        TextFormField(
          controller: urlController,
          onChanged: (value) {
            url = value;
          },
        ),
      ],
    );
  }

  @override
  void save() {
    url = urlController.text;
  }

  @override
  void cancel() {
    urlController.text = url;
  }

  @override
  void dispose() {
    urlController.dispose();
  }
}
