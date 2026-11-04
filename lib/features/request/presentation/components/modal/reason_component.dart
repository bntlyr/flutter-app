import 'package:flutter/material.dart';
import 'request_modal_common.dart';

class ReasonComponent extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const ReasonComponent({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reason of request',
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF616161),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: kRequestInputFill,
            border: Border(
              bottom: BorderSide(
                color: errorText != null
                    ? const Color(0xFFD32F2F)
                    : kRequestHeaderTeal,
                width: 1.5,
              ),
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF212121)),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.all(8),
                  ),
                  onChanged: onChanged,
                ),
              ),
              const Positioned(
                right: 2,
                bottom: 2,
                child: IgnorePointer(
                  child: CustomPaint(
                    size: Size(12, 12),
                    painter: TextareaGripperPainter(),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              errorText!,
              style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 10),
            ),
          ),
      ],
    );
  }
}
