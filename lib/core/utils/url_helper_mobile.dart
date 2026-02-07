import 'package:url_launcher/url_launcher.dart';
import 'url_helper.dart';

class MobileUrlHelper implements UrlHelper {
  @override
  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

UrlHelper getUrlHelper() => MobileUrlHelper();
