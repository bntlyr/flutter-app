import 'package:flutter/material.dart';
import 'request_modal_common.dart';

class RequestTypeAndFilingDate extends StatefulWidget {
  final String? selectedRequestType;
  final List<String> requestTypes;
  final ValueChanged<String?> onTypeChanged;
  final String filingDate;

  const RequestTypeAndFilingDate({
    super.key,
    required this.selectedRequestType,
    required this.requestTypes,
    required this.onTypeChanged,
    required this.filingDate,
  });

  @override
  State<RequestTypeAndFilingDate> createState() =>
      _RequestTypeAndFilingDateState();
}

class _RequestTypeAndFilingDateState extends State<RequestTypeAndFilingDate> {
  final LayerLink _requestTypeLayerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggleDropdown() {
    if (_overlayEntry != null) {
      _closeDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    _closeDropdown();
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (ctx) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _closeDropdown,
                child: Container(color: Colors.transparent),
              ),
            ),
            CompositedTransformFollower(
              link: _requestTypeLayerLink,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              offset: const Offset(0, 2),
              child: Material(
                elevation: 4,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(2),
                color: Colors.white,
                child: Container(
                  width: 175,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InkWell(
                        onTap: () {
                          widget.onTypeChanged(null);
                          _closeDropdown();
                        },
                        child: Container(
                          height: 34,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.centerLeft,
                          child: const Text('', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      ...widget.requestTypes.map((type) {
                        final isSelected = widget.selectedRequestType == type;
                        return InkWell(
                          onTap: () {
                            widget.onTypeChanged(type);
                            _closeDropdown();
                          },
                          child: Container(
                            height: 34,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            color: isSelected
                                ? const Color(0xFFEEEEEE)
                                : Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    type,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: const Color(0xFF212121),
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check,
                                      color: kRequestHeaderTeal, size: 16),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: Type of Request
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Type of Request',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF616161),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              CompositedTransformTarget(
                link: _requestTypeLayerLink,
                child: InkWell(
                  key: const Key('request_type_dropdown_trigger'),
                  onTap: _toggleDropdown,
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: const BoxDecoration(
                      color: kRequestInputFill,
                      border: Border(
                        bottom:
                            BorderSide(color: kRequestHeaderTeal, width: 1.5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.selectedRequestType ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF212121),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: kRequestHeaderTeal,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),

        // Right: Date of Filing
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Date of Filing',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF616161),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                    bottom: BorderSide(color: kRequestHeaderTeal, width: 1.5),
                  ),
                ),
                child: Text(
                  widget.filingDate,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF212121),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
