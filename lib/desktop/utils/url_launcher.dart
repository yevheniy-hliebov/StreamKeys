import 'package:url_launcher/url_launcher.dart' as url_launcher;
class UrlLauncher {
  Future<bool> canLaunchUrl(Uri uri) => url_launcher.canLaunchUrl(uri);
  Future<bool> launchUrl(Uri uri) => url_launcher.launchUrl(uri);
}
