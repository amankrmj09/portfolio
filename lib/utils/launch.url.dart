import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlExternal(String url) async {
  if (url.isEmpty) return;
  final uri = Uri.parse(url);
  try {
    // On web (including WASM), canLaunchUrl always returns false for http/https,
    // so we skip the check on web and attempt to launch directly.
    if (kIsWeb) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
    } else {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
          webOnlyWindowName: '_blank',
        );
      }
    }
  } catch (_) {
    // Silently ignore launch errors to prevent WASM crashes
  }
}
