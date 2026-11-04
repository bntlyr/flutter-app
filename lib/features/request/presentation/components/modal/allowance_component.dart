import 'package:flutter/material.dart';
import 'request_modal_common.dart';

class AllowanceComponent extends StatelessWidget {
  final List<String> allowanceOptions;
  final String? selectedAllowance;
  final ValueChanged<String> onAllowanceChanged;
  final DateTime? allowanceDate;
  final ValueChanged<DateTime> onDateChanged;
  final String? dateError;
  final String? optionError;

  const AllowanceComponent({
    super.key,
    required this.allowanceOptions,
    required this.selectedAllowance,
    required this.onAllowanceChanged,
    required this.allowanceDate,
    required this.onDateChanged,
    this.dateError,
    this.optionError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildRequestSectionHeader('Allowance'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: buildRequestDateField(
                context: context,
                label: 'Date applied in',
                value: allowanceDate,
                errorText: dateError,
                onSelected: onDateChanged,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: allowanceOptions.map((opt) {
            final isSelected = selectedAllowance == opt;
            return InkWell(
              onTap: () => onAllowanceChanged(opt),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? kRequestHeaderTeal
                            : const Color(0xFF757575),
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(2.5),
                    child: isSelected
                        ? Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: kRequestHeaderTeal,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    opt,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF212121),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        if (optionError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              optionError!,
              style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 10),
            ),
          ),
      ],
    );
  }
}
