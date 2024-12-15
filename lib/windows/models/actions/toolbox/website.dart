import 'package:streamkeys/windows/models/base_action.dart';
import 'package:url_launcher/url_launcher.dart';

class Website extends BaseAction {
  String url;
  final TextEditingController urlController = TextEditingController();

  static const String actionTypeName = 'Website';

  Website({this.url = ''}) : super(actionType: actionTypeName) {
    urlController.text = url;
  }

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
      'url': url,
    };
  }

  @override
  void clear() {
    url = '';
    urlController.clear();
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
