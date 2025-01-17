import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class URLLauncherService {
  Future<String?> launchUrl(String url) async {
    final uri = Uri.tryParse(url);

    if (uri == null) return 'A URL é inválida';

    try {
      final bool = await launcher.launchUrl(uri);

      debugPrint('Url opened: $bool');

      return null;
    } catch (e) {
      return 'Não foi possível abrir a URL';
    }
  }

  Future<String?> launchURI(Uri uri) async {
    try {
      await launcher.launchUrl(uri);
      return null;
    } catch (e) {
      return 'Não foi possível abrir a URL';
    }
  }
}
