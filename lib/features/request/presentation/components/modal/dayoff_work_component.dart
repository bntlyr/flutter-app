import 'package:flutter/material.dart';
import 'request_modal_common.dart';

class DayoffWorkComponent extends StatefulWidget {
  final String typeOfDayoffWork;
  final ValueChanged<String> onTypeChanged;
  final DateTime? generalDate;
  final ValueChanged<DateTime> onGeneralDateChanged;
  final String? generalDateError;
  final DateTime? offsetFromDate;
  final DateTime? offsetToDate;
  final ValueChanged<DateTime> onOffsetFromDateChanged;
  final ValueChanged<DateTime> onOffsetToDateChanged;
  final String? offsetFromDateError;
  final String? offsetToDateError;

  const DayoffWorkComponent({
    super.key,
    required this.typeOfDayoffWork,
    required this.onTypeChanged,
    required this.generalDate,
    required this.onGeneralDateChanged,
    this.generalDateError,
    required this.offsetFromDate,
    required this.offsetToDate,
    required this.onOffsetFromDateChanged,
    required this.onOffsetToDateChanged,
    this.offsetFromDateError,
    this.offsetToDateError,
  });

  @override
  State<DayoffWorkComponent> createState() => _DayoffWorkComponentState();
}

class _DayoffWorkComponentState extends State<DayoffWorkComponent> {
  final LayerLink _layerLink = LayerLink();
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
    const options = ['General', 'Offset'];

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
              link: _layerLink,
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
                    children: options.map((opt) {
                      final isSelected = widget.typeOfDayoffWork == opt;
                      return InkWell(
                        onTap: () {
                          widget.onTypeChanged(opt);
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
                              Text(
                                opt,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: const Color(0xFF212121),
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check,
                                    color: kRequestHeaderTeal, size: 16),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
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
    final bool isGeneral = widget.typeOfDayoffWork == 'General';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildRequestSectionHeader('Dayoff Work Detail'),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Type of Dayoff ...',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF616161),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  CompositedTransformTarget(
                    link: _layerLink,
                    child: InkWell(
                      key: const Key('dayoff_type_dropdown_trigger'),
                      onTap: _showDropdown,
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: const BoxDecoration(
                          color: kRequestInputFill,
                          border: Border(
                            bottom: BorderSide(
                                color: kRequestHeaderTeal, width: 1.5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.typeOfDayoffWork,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info, color: kRequestInfoColor, size: 22),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        isGeneral
                            ? 'This offday work will be compensated at the additional rate'
                            : 'This offday work will be compensated at normal rate',
                        style: const TextStyle(
                          color: kRequestInfoColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (isGeneral)
          Row(
            children: [
              Expanded(
                child: buildRequestDateField(
                  context: context,
                  label: 'Date applied in',
                  value: widget.generalDate,
                  errorText: widget.generalDateError,
                  onSelected: widget.onGeneralDateChanged,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(child: SizedBox.shrink()),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: buildRequestDateField(
                  context: context,
                  label: 'From',
                  value: widget.offsetFromDate,
                  errorText: widget.offsetFromDateError,
                  onSelected: widget.onOffsetFromDateChanged,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: buildRequestDateField(
                  context: context,
                  label: 'To',
                  value: widget.offsetToDate,
                  errorText: widget.offsetToDateError,
                  onSelected: widget.onOffsetToDateChanged,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
