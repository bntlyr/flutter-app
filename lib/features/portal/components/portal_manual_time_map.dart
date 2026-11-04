import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Embedded map container for PortalManualTimeDialog.
/// Displays Google Maps via WebView when GPS coordinates are available,
/// or an indicator / error message while retrieving device location.
class PortalManualTimeMap extends StatelessWidget {
  final WebViewController controller;
  final double? latitude;
  final double? longitude;
  final bool isLoadingLocation;
  final bool isLoadingMap;
  final String address;
  final Color themeColor;
  final double height;

  const PortalManualTimeMap({
    super.key,
    required this.controller,
    required this.latitude,
    required this.longitude,
    required this.isLoadingLocation,
    required this.isLoadingMap,
    required this.address,
    this.themeColor = const Color(0xFF50B5A6),
    this.height = 135,
  });

  static String getGoogleMapsHtml(double lat, double lng) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    html, body { width: 100%; height: 100%; overflow: hidden; background: #e5e3df; }
    iframe { width: 100%; height: 100%; border: 0; display: block; }
  </style>
</head>
<body>
  <iframe 
    src="https://maps.google.com/maps?q=$lat,$lng&hl=en&z=19&output=embed" 
    allowfullscreen>
  </iframe>
</body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFBDBDBD), width: 1),
      ),
      child: Stack(
        children: [
          if (latitude != null && longitude != null)
            WebViewWidget(controller: controller)
          else if (isLoadingLocation)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: themeColor,
                    strokeWidth: 2.5,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Acquiring device GPS...',
                    style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
                  ),
                ],
              ),
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_off,
                        color: Color(0xFF9E9E9E), size: 36),
                    const SizedBox(height: 6),
                    Text(
                      address,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 11.5, color: Color(0xFF757575)),
                    ),
                  ],
                ),
              ),
            ),
          if (latitude != null && (isLoadingMap || isLoadingLocation))
            Center(
              child: CircularProgressIndicator(
                color: themeColor,
                strokeWidth: 2.5,
              ),
            ),
        ],
      ),
    );
  }
}
