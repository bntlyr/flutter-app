import 'package:flutter/material.dart';
import 'package:flutter_app/shared/widgets/calendar/calendar_cut_off.dart';

/// Top header for Mobile DTR:
/// - Refresh logs button
/// - Cut-off date range input with anchored CalendarCutOff overlay picker
class DtrCutoffHeader extends StatefulWidget {
  final String cutoffText;
  final ValueChanged<String> onCutoffChanged;
  final VoidCallback onRefreshLogs;
  final bool isRefreshing;

  const DtrCutoffHeader({
    super.key,
    required this.cutoffText,
    required this.onCutoffChanged,
    required this.onRefreshLogs,
    this.isRefreshing = false,
  });

  @override
  State<DtrCutoffHeader> createState() => _DtrCutoffHeaderState();
}

class _DtrCutoffHeaderState extends State<DtrCutoffHeader> {
  final LayerLink _cutoffLayerLink = LayerLink();
  OverlayEntry? _cutoffOverlayEntry;

  void _closeCutoffPicker() {
    _cutoffOverlayEntry?.remove();
    _cutoffOverlayEntry = null;
  }

  void _showCutoffPicker() {
    _closeCutoffPicker();
    final overlay = Overlay.of(context);
    _cutoffOverlayEntry = OverlayEntry(
      builder: (ctx) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _closeCutoffPicker,
              ),
            ),
            Positioned(
              width: 275,
              child: CompositedTransformFollower(
                link: _cutoffLayerLink,
                showWhenUnlinked: false,
                targetAnchor: Alignment.bottomLeft,
                followerAnchor: Alignment.topLeft,
                offset: const Offset(0, 4),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: CalendarCutOff(
                    selectedCutoff: widget.cutoffText,
                    onCutoffSelected: (newRange) {
                      widget.onCutoffChanged(newRange);
                      _closeCutoffPicker();
                    },
                    onClose: _closeCutoffPicker,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_cutoffOverlayEntry!);
  }

  @override
  void dispose() {
    _closeCutoffPicker();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const tealColor = Color(0xFF50B5A6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Refresh logs button at top-right
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: widget.isRefreshing ? null : widget.onRefreshLogs,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.update,
                    size: 18,
                    color: tealColor,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.isRefreshing ? 'Downloading...' : 'Refresh logs',
                    style: const TextStyle(
                      color: tealColor,
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),

        // 2. Cut-off label
        const Text(
          'Cut-off',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 5),

        // 3. Cut-off Input Box with calendar icon
        CompositedTransformTarget(
          link: _cutoffLayerLink,
          child: InkWell(
            onTap: _showCutoffPicker,
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF1E293B), width: 1.2),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.cutoffText,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 18,
                    color: Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
