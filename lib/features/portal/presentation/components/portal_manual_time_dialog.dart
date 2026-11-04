import 'package:flutter/material.dart';
import 'package:flutter_app/services/location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_app/features/request/presentation/components/modal/request_modal_dialog.dart';
import 'portal_manual_time_map.dart';

/// Modal bottom sheet for Manual Time-In and Manual Time-Out.
/// Retrieves actual GPS coordinates via Geolocator and address via Geocoding,
/// displays map view of the coordinates, acknowledgement checkbox,
/// and saves record to SharedPreferences on confirmation.
class PortalManualTimeDialog extends StatefulWidget {
  final bool isTimeIn;
  final VoidCallback? onConfirmed;

  const PortalManualTimeDialog({
    super.key,
    required this.isTimeIn,
    this.onConfirmed,
  });

  static const Color headerTeal = Color(0xFF50B5A6);
  static const Color buttonRed = Color(0xFFA94442);
  static const Color defaultBorder = Color(0xFFD1D5DB);

  static Future<bool?> show({
    required BuildContext context,
    required bool isTimeIn,
    VoidCallback? onConfirmed,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (ctx) => PortalManualTimeDialog(
        isTimeIn: isTimeIn,
        onConfirmed: onConfirmed,
      ),
    );
  }

  @override
  State<PortalManualTimeDialog> createState() => _PortalManualTimeDialogState();
}

class _PortalManualTimeDialogState extends State<PortalManualTimeDialog> {
  late final WebViewController _controller;
  bool _isLoadingMap = false;
  bool _isLoadingLocation = true;
  bool _acknowledged = false;

  double? _latitude;
  double? _longitude;
  double? _accuracy;
  String _address = 'Acquiring current GPS location...';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoadingMap = false);
          },
        ),
      );

    _fetchRealCoordinates();
  }

  void _showLocationMessage(String msg) {
    if (!mounted) return;
    setState(() {
      _latitude = null;
      _longitude = null;
      _accuracy = null;
      _isLoadingLocation = false;
      _address = msg;
    });
  }

  Future<void> _fetchRealCoordinates() async {
    if (!mounted) return;
    setState(() {
      _isLoadingLocation = true;
      _address = 'Acquiring current GPS location...';
    });

    final result = await LocationService.getCurrentLocation();

    if (!mounted) return;

    if (result.isSuccess &&
        result.latitude != null &&
        result.longitude != null) {
      setState(() {
        _latitude = result.latitude;
        _longitude = result.longitude;
        _accuracy = result.accuracy;
        _address = result.formattedAddress;
        _isLoadingLocation = false;
        _isLoadingMap = true;
      });
      _controller.loadHtmlString(
        PortalManualTimeMap.getGoogleMapsHtml(
            result.latitude!, result.longitude!),
        baseUrl: 'https://maps.google.com',
      );
    } else {
      _showLocationMessage(
          result.errorMessage ?? result.formattedAddress);
    }
  }

  Future<void> _handleConfirm() async {
    if (_latitude == null || _longitude == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now().toIso8601String();
      await prefs.setString(
          'portal_last_log_type', widget.isTimeIn ? 'IN' : 'OUT');
      await prefs.setString('portal_last_log_time', now);
      await prefs.setString('portal_last_log_address', _address);
      await prefs.setDouble('portal_last_log_lat', _latitude!);
      await prefs.setDouble('portal_last_log_lng', _longitude!);
      if (_accuracy != null) {
        await prefs.setDouble('portal_last_log_accuracy', _accuracy!);
      }
    } catch (_) {}

    widget.onConfirmed?.call();
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewPadding.bottom > 0
        ? mediaQuery.viewPadding.bottom
        : mediaQuery.padding.bottom;
    final title = widget.isTimeIn ? 'Manual Time-In' : 'Manual Time-Out';

    return Container(
      constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.85),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
              color: Colors.black26, blurRadius: 10, offset: Offset(0, -2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Handle Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 6),
            alignment: Alignment.center,
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header Bar
          Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: PortalManualTimeDialog.headerTeal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                  ),
                ),
                InkWell(
                  key: const Key('manual_time_close_button'),
                  onTap: () => Navigator.of(context).pop(),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),

          // Body
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Map Frame
                  PortalManualTimeMap(
                    controller: _controller,
                    latitude: _latitude,
                    longitude: _longitude,
                    isLoadingLocation: _isLoadingLocation,
                    isLoadingMap: _isLoadingMap,
                    address: _address,
                    themeColor: PortalManualTimeDialog.headerTeal,
                    height: 135,
                  ),
                  const SizedBox(height: 8),

                  // My Place is Here:
                  const Text(
                    'My Place is Here:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF616161),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Address Box
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      border:
                          Border.all(color: PortalManualTimeDialog.defaultBorder),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      _address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF333333),
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Reload > Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 28,
                      child: ElevatedButton(
                        key: const Key('manual_time_reload_button'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PortalManualTimeDialog.buttonRed,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 0,
                          minimumSize: const Size(0, 28),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed:
                            _isLoadingLocation ? null : _fetchRealCoordinates,
                        child: _isLoadingLocation
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Reload >',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.5,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Acknowledgement Checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: Checkbox(
                          key: const Key('manual_time_acknowledge_checkbox'),
                          value: _acknowledged,
                          activeColor: PortalManualTimeDialog.headerTeal,
                          onChanged: (val) {
                            setState(() => _acknowledged = val ?? false);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'I acknowledge that my place is around here.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Apply for timelogs correction for errors >
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: InkWell(
                      key: const Key('manual_time_timelogs_link'),
                      onTap: () {
                        Navigator.of(context).pop();
                        RequestModalDialog.show(
                          context: context,
                          initialTypeOfRequest: 'Timelogs Correction',
                        );
                      },
                      child: const Text(
                        'Apply for timelogs correction for errors >',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF337AB7),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Pinned Action Buttons
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                6,
                16,
                14 + (bottomInset > 0 ? bottomInset : 4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 95,
                    height: 36,
                    child: OutlinedButton(
                      key: const Key('manual_time_cancel_button'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: PortalManualTimeDialog.headerTeal,
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        minimumSize: const Size(80, 36),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: PortalManualTimeDialog.headerTeal,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 95,
                    height: 36,
                    child: ElevatedButton(
                      key: const Key('manual_time_confirm_button'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PortalManualTimeDialog.headerTeal,
                        disabledBackgroundColor: const Color(0xFFB2DFDB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        minimumSize: const Size(80, 36),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: (_acknowledged &&
                              _latitude != null &&
                              _longitude != null)
                          ? _handleConfirm
                          : null,
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                      ),
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
