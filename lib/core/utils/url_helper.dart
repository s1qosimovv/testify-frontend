import 'package:url_launcher/url_launcher.dart';

abstract class UrlHelper {
  Future<void> openUrl(String url);
}

UrlHelper getUrlHelper() => throw UnsupportedError('Cannot create UrlHelper');
