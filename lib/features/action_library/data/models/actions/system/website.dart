import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/action_library/data/models/base_action.dart';
import 'package:url_launcher/url_launcher.dart';

class Website extends BaseAction {
  String url;
  final TextEditingController urlController = TextEditingController();

  static const String actionTypeName = 'Website';

  Website({this.url = ''})
      : super(
          actionType: actionTypeName,
          actionName: 'Open website',
        );

  @override
  FutureVoid execute({dynamic data}) async {
    if (url.isNotEmpty) {
      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }

  @override
  Json toJson() {
    return {
      'action_type': actionType,
      'action_name': actionName,
      'url': url,
    };
  }

  @override
  void clear() {
    url = '';
  }

  @override
  Website copy() {
    return Website(url: url);
  }

  factory Website.fromJson(Json json) {
    return Website(
      url: json['url'] as String,
    );
  }

  @override
  List<Widget> formFields(BuildContext context) {
    return [
      TextFormField(
        controller: urlController,
        decoration: const InputDecoration(
          labelText: 'Url',
        ),
        onChanged: (value) {
          url = value;
        },
      ),
    ];
  }
}
