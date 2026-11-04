import 'package:flutter/material.dart';
import 'request_modal_common.dart';

class RequestModalActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  final bool isSubmitEnabled;

  const RequestModalActions({
    super.key,
    required this.onCancel,
    required this.onSubmit,
    this.isSubmitEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 10, 16, 16 + bottomPadding),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 38,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: kRequestHeaderTeal, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: kRequestHeaderTeal,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 38,
              child: ElevatedButton(
                onPressed: isSubmitEnabled ? onSubmit : null,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: kRequestHeaderTeal,
                  disabledBackgroundColor: const Color(0xFFF5F5F5),
                  disabledForegroundColor: const Color(0xFFE0E0E0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
