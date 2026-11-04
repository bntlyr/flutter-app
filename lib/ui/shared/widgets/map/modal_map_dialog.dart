import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Common Map Modal Dialog (modal-map) using webview_flutter.
/// Uses the free map embed link (OpenStreetMap) by default or Google Maps iframe HTML.
class ModalMapDialog extends StatefulWidget {
  final String title;
  final String locationTitle;
  final String address;
  final double latitude;
  final double longitude;
  final int zoom;
  final bool useFreeLink;
  final String? customUrl;

  static const Color _headerTeal = Color(0xFF50B5A6);

  const ModalMapDialog({
    super.key,
    this.title = 'Map',
    this.locationTitle = 'My Location is Around Here:',
    this.address =
        'Rosa Homes, Landayan, San Pedro, Laguna, Calabarzon, 4023, Philippines',
    this.latitude = 14.3597,
    this.longitude = 121.0538,
    this.zoom = 19,
    this.useFreeLink = false,
    this.customUrl,
  });

  /// Static helper to display the ModalMapDialog as a fullscreen route
  /// sliding in from right to left (mobile style).
  static Future<T?> show<T>({
    required BuildContext context,
    String title = 'Map',
    String locationTitle = 'My Location is Around Here:',
    String address =
        'Rosa Homes, Landayan, San Pedro, Laguna, Calabarzon, 4023, Philippines',
    double latitude = 14.3597,
    double longitude = 121.0538,
    int zoom = 19,
    bool useFreeLink = false,
    String? customUrl,
  }) {
    return Navigator.of(context, rootNavigator: true).push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (ctx, animation, secondaryAnimation) => ModalMapDialog(
          title: title,
          locationTitle: locationTitle,
          address: address,
          latitude: latitude,
          longitude: longitude,
          zoom: zoom,
          useFreeLink: useFreeLink,
          customUrl: customUrl,
        ),
        transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  State<ModalMapDialog> createState() => _ModalMapDialogState();
}

class _ModalMapDialogState extends State<ModalMapDialog> {
  late final WebViewController _controller;
  bool _isLoading = true;

  String _getFreeMapUrl() {
    final minLng = widget.longitude - 0.006;
    final minLat = widget.latitude - 0.004;
    final maxLng = widget.longitude + 0.006;
    final maxLat = widget.latitude + 0.004;
    return 'https://www.openstreetmap.org/export/embed.html?bbox=$minLng%2C$minLat%2C$maxLng%2C$maxLat&layer=mapnik&marker=${widget.latitude}%2C${widget.longitude}';
  }

  String _getGoogleMapsIframeHtml() {
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
    src="https://maps.google.com/maps?q=${widget.latitude},${widget.longitude}&hl=en&z=${widget.zoom}&output=embed" 
    allowfullscreen>
  </iframe>
</body>
</html>
''';
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
        ),
      );

    if (widget.customUrl != null) {
      _controller.loadRequest(Uri.parse(widget.customUrl!));
    } else if (widget.useFreeLink) {
      // Free open map link: OpenStreetMap with pinned marker (no API key, no iframe restriction)
      _controller.loadRequest(Uri.parse(_getFreeMapUrl()));
    } else {
      // Google Maps Embed wrapped in iframe HTML
      _controller.loadHtmlString(
        _getGoogleMapsIframeHtml(),
        baseUrl: 'https://maps.google.com',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header Bar: [ Back Arrow ] [ Map ] [ X ]
          Container(
            color: ModalMapDialog._headerTeal,
            child: SafeArea(
              bottom: false,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    InkWell(
                      key: const Key('modal_map_close_button'),
                      onTap: () => Navigator.of(context).pop(),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.arrow_back, color: Colors.white, size: 22),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Fullscreen WebView Map Area
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: ModalMapDialog._headerTeal,
                      strokeWidth: 2.5,
                    ),
                  ),
              ],
            ),
          ),

          // 3. Location Details Box at Bottom
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.locationTitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.address,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF616161),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fullscreen GoogleMapPage using webview_flutter with free link or iframe
class GoogleMapPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  final int zoom;
  final bool useFreeLink;

  const GoogleMapPage({
    super.key,
    this.latitude = 14.3597,
    this.longitude = 121.0538,
    this.zoom = 19,
    this.useFreeLink = false,
  });

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    if (widget.useFreeLink) {
      final minLng = widget.longitude - 0.006;
      final minLat = widget.latitude - 0.004;
      final maxLng = widget.longitude + 0.006;
      final maxLat = widget.latitude + 0.004;
      final freeUrl =
          'https://www.openstreetmap.org/export/embed.html?bbox=$minLng%2C$minLat%2C$maxLng%2C$maxLat&layer=mapnik&marker=${widget.latitude}%2C${widget.longitude}';
      controller.loadRequest(Uri.parse(freeUrl));
    } else {
      final html = '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    html, body { width: 100%; height: 100%; overflow: hidden; }
    iframe { width: 100%; height: 100%; border: 0; }
  </style>
</head>
<body>
  <iframe src="https://maps.google.com/maps?q=${widget.latitude},${widget.longitude}&hl=en&z=${widget.zoom}&output=embed"></iframe>
</body>
</html>
''';
      controller.loadHtmlString(html, baseUrl: 'https://maps.google.com');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
        backgroundColor: const Color(0xFF50B5A6),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
