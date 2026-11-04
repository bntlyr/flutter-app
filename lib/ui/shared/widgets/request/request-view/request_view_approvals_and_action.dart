import 'package:flutter/material.dart';
import 'request_view_common.dart';

/// Approver details and Cancel Request action button (Pic 4).
class RequestViewApprovalsAndAction extends StatelessWidget {
  final RequestApprovalStatus status;
  final String? preApprovedBy;
  final String? preApprovedDate;
  final String? approvedBy;
  final String? approvedDate;
  final String? rejectedBy;
  final String? rejectedDate;
  final VoidCallback? onCancelRequest;

  const RequestViewApprovalsAndAction({
    super.key,
    required this.status,
    this.preApprovedBy,
    this.preApprovedDate,
    this.approvedBy,
    this.approvedDate,
    this.rejectedBy,
    this.rejectedDate,
    this.onCancelRequest,
  });

  Widget _buildApprovalsSection({
    required String approverName,
    required String rejecterName,
  }) {
    switch (status) {
      case RequestApprovalStatus.approved:
        return Column(
          children: [
            buildRequestViewDataRow(
              'Pre-approved by',
              '---\n---',
            ),
            const SizedBox(height: 10),
            buildRequestViewDataRow(
              'Approved by',
              '$approverName\n${approvedDate ?? 'May 04, 2026 11:00'}',
            ),
          ],
        );

      case RequestApprovalStatus.preApproved:
        return Column(
          children: [
            buildRequestViewDataRow(
              'Pre-approved by',
              '${preApprovedBy ?? 'Panisales, Christine Mae'}\n${preApprovedDate ?? 'August 26, 2025 16:27'}',
            ),
            const SizedBox(height: 10),
            buildRequestViewDataRow(
              'Approved by',
              '',
            ),
          ],
        );

      case RequestApprovalStatus.rejected:
        return Column(
          children: [
            buildRequestViewDataRow(
              'Pre-approved by',
              '---\n---',
            ),
            const SizedBox(height: 10),
            buildRequestViewDataRow(
              'Rejected By',
              '$rejecterName\n${rejectedDate ?? 'May 18, 2026 09:53'}',
            ),
          ],
        );

      case RequestApprovalStatus.pending:
        return Column(
          children: [
            buildRequestViewDataRow(
              'Pre-approved by',
              '',
            ),
            const SizedBox(height: 10),
            buildRequestViewDataRow(
              'Approved by',
              '',
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final approverName = approvedBy ?? 'Paul Javinez';
    final rejecterName = rejectedBy ?? 'Paul Javinez';
    final isCancelable = status == RequestApprovalStatus.pending ||
        status == RequestApprovalStatus.preApproved;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        const Divider(height: 1, color: kRequestViewDividerColor),
        const SizedBox(height: 10),

        // Approvals Section
        _buildApprovalsSection(
          approverName: approverName,
          rejecterName: rejecterName,
        ),

        const SizedBox(height: 20),

        // Cancel Request Button
        SizedBox(
          height: 40,
          width: double.infinity,
          child: OutlinedButton(
            onPressed: isCancelable
                ? () {
                    onCancelRequest?.call();
                    Navigator.of(context).pop();
                  }
                : null,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isCancelable
                    ? kRequestViewHeaderTeal.withValues(alpha: 0.6)
                    : const Color(0xFFE0E0E0),
                width: 1.2,
              ),
              backgroundColor: isCancelable
                  ? const Color(0xFFE2F4F4).withValues(alpha: 0.3)
                  : const Color(0xFFFAFAFA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              'Cancel Request',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isCancelable
                    ? kRequestViewHeaderTeal
                    : const Color(0xFFE0E0E0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
