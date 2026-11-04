import 'package:flutter/material.dart';
import 'request_modal_common.dart';

class LeaveComponent extends StatefulWidget {
  final List<LeaveTypeOption> leaveTypes;
  final String? selectedLeaveType;
  final ValueChanged<String?> onLeaveTypeChanged;
  final bool isHalfDay;
  final bool isFullDay;
  final ValueChanged<bool> onHalfDayChanged;
  final ValueChanged<bool> onFullDayChanged;
  final DateTime? fromDate;
  final DateTime? toDate;
  final ValueChanged<DateTime> onFromDateChanged;
  final ValueChanged<DateTime> onToDateChanged;
  final String? leaveTypeError;
  final String? leaveDateError;

  const LeaveComponent({
    super.key,
    required this.leaveTypes,
    required this.selectedLeaveType,
    required this.onLeaveTypeChanged,
    required this.isHalfDay,
    required this.isFullDay,
    required this.onHalfDayChanged,
    required this.onFullDayChanged,
    required this.fromDate,
    required this.toDate,
    required this.onFromDateChanged,
    required this.onToDateChanged,
    this.leaveTypeError,
    this.leaveDateError,
  });

  @override
  State<LeaveComponent> createState() => _LeaveComponentState();
}

class _LeaveComponentState extends State<LeaveComponent> {
  final LayerLink _leaveTypeLayerLink = LayerLink();
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
              link: _leaveTypeLayerLink,
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
                          widget.onLeaveTypeChanged(null);
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
                      ...widget.leaveTypes.map((lt) {
                        final bool disabled = lt.isDisabled;
                        final bool isSelected =
                            widget.selectedLeaveType == lt.label;
                        return InkWell(
                          onTap: disabled
                              ? null
                              : () {
                                  widget.onLeaveTypeChanged(lt.label);
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
                                    lt.label,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: disabled
                                          ? const Color(0xFFBDBDBD)
                                          : const Color(0xFF212121),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildRequestSectionHeader('Leave'),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Type of Leave',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF616161),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  CompositedTransformTarget(
                    link: _leaveTypeLayerLink,
                    child: InkWell(
                      key: const Key('leave_type_dropdown_trigger'),
                      onTap: _showDropdown,
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: const BoxDecoration(
                          color: kRequestInputFill,
                          border: Border(
                            bottom: BorderSide(
                              color: kRequestHeaderTeal,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.selectedLeaveType ?? '',
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
                  if (widget.leaveTypeError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        widget.leaveTypeError!,
                        style: const TextStyle(
                          color: Color(0xFFD32F2F),
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => widget.onHalfDayChanged(!widget.isHalfDay),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: Checkbox(
                              value: widget.isHalfDay,
                              activeColor: kRequestHeaderTeal,
                              side: const BorderSide(
                                  color: Color(0xFF757575), width: 1.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)),
                              onChanged: (val) =>
                                  widget.onHalfDayChanged(val ?? false),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Half Day',
                            style: TextStyle(
                                fontSize: 11, color: Color(0xFF212121)),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => widget.onFullDayChanged(!widget.isFullDay),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: Checkbox(
                              value: widget.isFullDay,
                              activeColor: kRequestHeaderTeal,
                              side: const BorderSide(
                                  color: Color(0xFF757575), width: 1.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)),
                              onChanged: (val) =>
                                  widget.onFullDayChanged(val ?? false),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Full Day',
                            style: TextStyle(
                                fontSize: 11, color: Color(0xFF212121)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: buildRequestDateField(
                context: context,
                label: widget.isHalfDay ? 'Date applied in:' : 'From:',
                value: widget.fromDate,
                onSelected: widget.onFromDateChanged,
                errorText: widget.leaveDateError,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: widget.isFullDay
                  ? buildRequestDateField(
                      context: context,
                      label: 'To:',
                      value: widget.toDate,
                      onSelected: widget.onToDateChanged,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ],
    );
  }
}
