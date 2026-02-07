import 'dart:html' as html;
import 'url_helper.dart';

class WebUrlHelper implements UrlHelper {
  @override
  Future<void> openUrl(String url) async {
    html.window.open(url, '_blank');
  }
}

UrlHelper getUrlHelper() => WebUrlHelper();
