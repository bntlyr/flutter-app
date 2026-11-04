import 'package:flutter/material.dart';
import '../map/modal_map_dialog.dart';

/// Represents the approval status of a user request
enum RequestApprovalStatus {
  approved,
  preApproved,
  pending,
  rejected;

  static RequestApprovalStatus fromString(String status) {
    final lower = status.toLowerCase().replaceAll('-', '').replaceAll(' ', '');
    if (lower.contains('pre')) return RequestApprovalStatus.preApproved;
    if (lower.contains('app')) return RequestApprovalStatus.approved;
    if (lower.contains('rej')) return RequestApprovalStatus.rejected;
    return RequestApprovalStatus.pending;
  }

  String get label {
    switch (this) {
      case RequestApprovalStatus.approved:
        return 'Approved';
      case RequestApprovalStatus.preApproved:
        return 'Pre-Approved';
      case RequestApprovalStatus.pending:
        return 'Pending';
      case RequestApprovalStatus.rejected:
        return 'Rejected';
    }
  }

  Color get color {
    switch (this) {
      case RequestApprovalStatus.approved:
        return const Color(0xFF7FBFFF); // Soft Blue
      case RequestApprovalStatus.preApproved:
        return const Color(0xFF70D1A1); // Soft Green
      case RequestApprovalStatus.pending:
        return const Color(0xFFFAAB36); // Amber / Orange
      case RequestApprovalStatus.rejected:
        return const Color(0xFFFF7F7F); // Soft Coral / Red
    }
  }

  IconData get icon {
    switch (this) {
      case RequestApprovalStatus.approved:
      case RequestApprovalStatus.preApproved:
        return Icons.check;
      case RequestApprovalStatus.pending:
        return Icons.access_time;
      case RequestApprovalStatus.rejected:
        return Icons.close;
    }
  }
}

/// Common View Request Dialog matching web-app / mobile reference
class RequestViewDialog extends StatelessWidget {
  final String title;
  final String typeOfRequest;
  final String status;
  final String filingDate;
  final String? dateApplied;
  final String? reason;
  final String? leaveType;
  final String? leaveFrom;
  final String? leaveTo;
  final String? timeIn;
  final String? timeOut;
  final String? allowanceType;
  final String? dayoffType;
  final String? offsetFrom;
  final String? offsetTo;
  final String? workStart;
  final String? workBreakStart;
  final String? workBreakEnd;
  final String? workEnd;
  final String? totalHours;

  // Approver information
  final String? preApprovedBy;
  final String? preApprovedDate;
  final String? approvedBy;
  final String? approvedDate;
  final String? rejectedBy;
  final String? rejectedDate;

  // Location / Map information
  final String? locationTitle;
  final String? locationAddress;
  final double? latitude;
  final double? longitude;

  final VoidCallback? onCancelRequest;

  static const Color _headerTeal = Color(0xFF47A5A0);
  static const Color _dividerColor = Color(0xFFEEEEEE);

  const RequestViewDialog({
    super.key,
    this.title = 'Details of Request',
    required this.typeOfRequest,
    required this.status,
    required this.filingDate,
    this.dateApplied,
    this.reason,
    this.leaveType,
    this.leaveFrom,
    this.leaveTo,
    this.timeIn,
    this.timeOut,
    this.allowanceType,
    this.dayoffType,
    this.offsetFrom,
    this.offsetTo,
    this.workStart,
    this.workBreakStart,
    this.workBreakEnd,
    this.workEnd,
    this.totalHours,
    this.preApprovedBy,
    this.preApprovedDate,
    this.approvedBy,
    this.approvedDate,
    this.rejectedBy,
    this.rejectedDate,
    this.locationTitle,
    this.locationAddress,
    this.latitude,
    this.longitude,
    this.onCancelRequest,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String typeOfRequest,
    required String status,
    required String filingDate,
    String? dateApplied,
    String? reason,
    String? leaveType,
    String? leaveFrom,
    String? leaveTo,
    String? timeIn,
    String? timeOut,
    String? allowanceType,
    String? dayoffType,
    String? offsetFrom,
    String? offsetTo,
    String? workStart,
    String? workBreakStart,
    String? workBreakEnd,
    String? workEnd,
    String? totalHours,
    String? preApprovedBy,
    String? preApprovedDate,
    String? approvedBy,
    String? approvedDate,
    String? rejectedBy,
    String? rejectedDate,
    String? locationTitle,
    String? locationAddress,
    double? latitude,
    double? longitude,
    VoidCallback? onCancelRequest,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => RequestViewDialog(
        typeOfRequest: typeOfRequest,
        status: status,
        filingDate: filingDate,
        dateApplied: dateApplied,
        reason: reason,
        leaveType: leaveType,
        leaveFrom: leaveFrom,
        leaveTo: leaveTo,
        timeIn: timeIn,
        timeOut: timeOut,
        allowanceType: allowanceType,
        dayoffType: dayoffType,
        offsetFrom: offsetFrom,
        offsetTo: offsetTo,
        workStart: workStart,
        workBreakStart: workBreakStart,
        workBreakEnd: workBreakEnd,
        workEnd: workEnd,
        totalHours: totalHours,
        preApprovedBy: preApprovedBy,
        preApprovedDate: preApprovedDate,
        approvedBy: approvedBy,
        approvedDate: approvedDate,
        rejectedBy: rejectedBy,
        rejectedDate: rejectedDate,
        locationTitle: locationTitle,
        locationAddress: locationAddress,
        latitude: latitude,
        longitude: longitude,
        onCancelRequest: onCancelRequest,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusEnum = RequestApprovalStatus.fromString(status);
    final mediaQuery = MediaQuery.of(context);

    // Replace Approver / Rejecter name with "Paul Javinez" as requested
    final approverName = approvedBy ?? 'Paul Javinez';
    final rejecterName = rejectedBy ?? 'Paul Javinez';
    final isCancelable = statusEnum == RequestApprovalStatus.pending ||
        statusEnum == RequestApprovalStatus.preApproved;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      backgroundColor: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 420,
          maxHeight: mediaQuery.size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Header Bar: [ Details of Request ]  [ X ]
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: _headerTeal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Scrollable Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Status Circle Badge
                    Center(
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: statusEnum.color,
                        ),
                        child: Center(
                          child: Icon(
                            statusEnum.icon,
                            color: Colors.white,
                            size: 42,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Status Text
                    Center(
                      child: Text(
                        statusEnum.label,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: statusEnum.color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Top common fields: Date of Filing & Type of Request
                    _buildDataRow('Date of Filing', filingDate),
                    const SizedBox(height: 8),
                    _buildDataRow('Type of Request', typeOfRequest),

                    const SizedBox(height: 10),
                    const Divider(height: 1, color: _dividerColor),
                    const SizedBox(height: 10),

                    // Type Specific Fields
                    ..._buildTypeSpecificRows(),

                    const SizedBox(height: 10),
                    const Divider(height: 1, color: _dividerColor),
                    const SizedBox(height: 10),

                    // Reason Field
                    _buildDataRow(
                      'Reason',
                      (reason != null && reason!.isNotEmpty) ? reason! : '--',
                    ),

                    const SizedBox(height: 10),
                    const Divider(height: 1, color: _dividerColor),
                    const SizedBox(height: 10),

                    // Map Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 140,
                          child: Text(
                            'Map',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF616161),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            key: const Key('see_applied_location_button'),
                            onTap: () {
                              ModalMapDialog.show(
                                context: context,
                                locationTitle: locationTitle ?? 'My Location is Around Here:',
                                address: locationAddress ??
                                    'Rosa Homes, Landayan, San Pedro, Laguna, Calabarzon, 4023, Philippines',
                                latitude: latitude ?? 14.3597,
                                longitude: longitude ?? 121.0538,
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/map-pin-green.png',
                                  width: 22,
                                  height: 22,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) => const Icon(
                                    Icons.location_on,
                                    size: 20,
                                    color: Color(0xFF50B5A6),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Flexible(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'See the applied location',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF50B5A6),
                                            decoration: TextDecoration.underline,
                                            decorationColor: Color(0xFF50B5A6),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' >',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF50B5A6),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    const Divider(height: 1, color: _dividerColor),
                    const SizedBox(height: 10),

                    // Approvals Section
                    _buildApprovalsSection(
                      status: statusEnum,
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
                                ? _headerTeal.withValues(alpha: 0.6)
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
                                ? _headerTeal
                                : const Color(0xFFE0E0E0),
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
      ),
    );
  }

  List<Widget> _buildTypeSpecificRows() {
    switch (typeOfRequest) {
      case 'Leave':
        final isHalf = dateApplied != null && dateApplied!.contains('(H)');
        return [
          _buildDataRow('Type of Leave', leaveType ?? 'Vacation'),
          const SizedBox(height: 8),
          if (isHalf) ...[
            _buildDataRow('Date applied in', dateApplied ?? '--'),
          ] else ...[
            _buildDataRow('Leave From', leaveFrom ?? dateApplied ?? '--'),
            const SizedBox(height: 8),
            _buildDataRow('Leave To', leaveTo ?? '--'),
          ],
        ];

      case 'Timelogs Correction':
        return [
          if (dateApplied != null) ...[
            _buildDataRow('Date applied in', dateApplied!),
            const SizedBox(height: 8),
          ],
          _buildDataRow('Time In', timeIn ?? '--'),
          const SizedBox(height: 8),
          _buildDataRow('Time Out', timeOut ?? '00:00'),
        ];

      case 'Allowance':
        return [
          _buildDataRow('Date applied in', dateApplied ?? filingDate),
          const SizedBox(height: 8),
          _buildDataRow('Type of Allowance', allowanceType ?? 'Perfect Attendance'),
        ];

      case 'Dayoff Work':
        if (dayoffType == 'Offset') {
          return [
            _buildDataRow('Type of Dayoff Work', 'Offset'),
            const SizedBox(height: 8),
            _buildDataRow('Change From', offsetFrom ?? dateApplied ?? '--'),
            const SizedBox(height: 8),
            _buildDataRow('Change To', offsetTo ?? '--'),
          ];
        } else {
          return [
            _buildDataRow('Type of Dayoff Work', 'General'),
            const SizedBox(height: 8),
            _buildDataRow('Date applied in', dateApplied ?? filingDate),
          ];
        }

      case 'Reshift':
        return [
          _buildDataRow('Date applied in', dateApplied ?? filingDate),
          const SizedBox(height: 8),
          _buildDataRow('Work Start', workStart ?? '10:00'),
          const SizedBox(height: 8),
          _buildDataRow('Work Break Start', workBreakStart ?? '14:00'),
          const SizedBox(height: 8),
          _buildDataRow('Work Break End', workBreakEnd ?? '15:00'),
          const SizedBox(height: 8),
          _buildDataRow('Work End', workEnd ?? '19:00'),
          const SizedBox(height: 8),
          _buildDataRow('Total', totalHours ?? '8 Hours'),
        ];

      case 'Overtime':
      default:
        return [
          _buildDataRow('Date applied in', dateApplied ?? filingDate),
        ];
    }
  }

  Widget _buildApprovalsSection({
    required RequestApprovalStatus status,
    required String approverName,
    required String rejecterName,
  }) {
    switch (status) {
      case RequestApprovalStatus.approved:
        return Column(
          children: [
            _buildDataRow(
              'Pre-approved by',
              '---\n---',
            ),
            const SizedBox(height: 10),
            _buildDataRow(
              'Approved by',
              '$approverName\n${approvedDate ?? 'May 04, 2026 11:00'}',
            ),
          ],
        );

      case RequestApprovalStatus.preApproved:
        return Column(
          children: [
            _buildDataRow(
              'Pre-approved by',
              '${preApprovedBy ?? 'Panisales, Christine Mae'}\n${preApprovedDate ?? 'August 26, 2025 16:27'}',
            ),
            const SizedBox(height: 10),
            _buildDataRow(
              'Approved by',
              '',
            ),
          ],
        );

      case RequestApprovalStatus.rejected:
        return Column(
          children: [
            _buildDataRow(
              'Pre-approved by',
              '---\n---',
            ),
            const SizedBox(height: 10),
            _buildDataRow(
              'Rejected By',
              '$rejecterName\n${rejectedDate ?? 'May 18, 2026 09:53'}',
            ),
          ],
        );

      case RequestApprovalStatus.pending:
        return Column(
          children: [
            _buildDataRow(
              'Pre-approved by',
              '',
            ),
            const SizedBox(height: 10),
            _buildDataRow(
              'Approved by',
              '',
            ),
          ],
        );
    }
  }

  Widget _buildDataRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF616161),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF212121),
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
