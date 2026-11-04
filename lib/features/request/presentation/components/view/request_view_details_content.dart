import 'package:flutter/material.dart';
import 'package:flutter_app/shared/widgets/map/modal_map_dialog.dart';
import 'request_view_common.dart';

/// Request details content displaying filing date, request type,
/// type-specific breakdown rows, reason, and location map link (Pic 3).
class RequestViewDetailsContent extends StatelessWidget {
  final String filingDate;
  final String typeOfRequest;
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
  final String? locationTitle;
  final String? locationAddress;
  final double? latitude;
  final double? longitude;

  const RequestViewDetailsContent({
    super.key,
    required this.filingDate,
    required this.typeOfRequest,
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
    this.locationTitle,
    this.locationAddress,
    this.latitude,
    this.longitude,
  });

  List<Widget> _buildTypeSpecificRows() {
    switch (typeOfRequest) {
      case 'Leave':
        final isHalf = dateApplied != null && dateApplied!.contains('(H)');
        return [
          buildRequestViewDataRow('Type of Leave', leaveType ?? 'Vacation'),
          const SizedBox(height: 8),
          if (isHalf) ...[
            buildRequestViewDataRow('Date applied in', dateApplied ?? '--'),
          ] else ...[
            buildRequestViewDataRow(
                'Leave From', leaveFrom ?? dateApplied ?? '--'),
            const SizedBox(height: 8),
            buildRequestViewDataRow('Leave To', leaveTo ?? '--'),
          ],
        ];

      case 'Timelogs Correction':
        return [
          if (dateApplied != null) ...[
            buildRequestViewDataRow('Date applied in', dateApplied!),
            const SizedBox(height: 8),
          ],
          buildRequestViewDataRow('Time In', timeIn ?? '--'),
          const SizedBox(height: 8),
          buildRequestViewDataRow('Time Out', timeOut ?? '00:00'),
        ];

      case 'Allowance':
        return [
          buildRequestViewDataRow('Date applied in', dateApplied ?? filingDate),
          const SizedBox(height: 8),
          buildRequestViewDataRow(
              'Type of Allowance', allowanceType ?? 'Perfect Attendance'),
        ];

      case 'Dayoff Work':
        if (dayoffType == 'Offset') {
          return [
            buildRequestViewDataRow('Type of Dayoff Work', 'Offset'),
            const SizedBox(height: 8),
            buildRequestViewDataRow(
                'Change From', offsetFrom ?? dateApplied ?? '--'),
            const SizedBox(height: 8),
            buildRequestViewDataRow('Change To', offsetTo ?? '--'),
          ];
        } else {
          return [
            buildRequestViewDataRow('Type of Dayoff Work', 'General'),
            const SizedBox(height: 8),
            buildRequestViewDataRow(
                'Date applied in', dateApplied ?? filingDate),
          ];
        }

      case 'Reshift':
        return [
          buildRequestViewDataRow('Date applied in', dateApplied ?? filingDate),
          const SizedBox(height: 8),
          buildRequestViewDataRow('Work Start', workStart ?? '10:00'),
          const SizedBox(height: 8),
          buildRequestViewDataRow(
              'Work Break Start', workBreakStart ?? '14:00'),
          const SizedBox(height: 8),
          buildRequestViewDataRow('Work Break End', workBreakEnd ?? '15:00'),
          const SizedBox(height: 8),
          buildRequestViewDataRow('Work End', workEnd ?? '19:00'),
          const SizedBox(height: 8),
          buildRequestViewDataRow('Total', totalHours ?? '8 Hours'),
        ];

      case 'Overtime':
      default:
        return [
          buildRequestViewDataRow('Date applied in', dateApplied ?? filingDate),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top common fields: Date of Filing & Type of Request
        buildRequestViewDataRow('Date of Filing', filingDate),
        const SizedBox(height: 8),
        buildRequestViewDataRow('Type of Request', typeOfRequest),

        const SizedBox(height: 10),
        const Divider(height: 1, color: kRequestViewDividerColor),
        const SizedBox(height: 10),

        // Type Specific Fields
        ..._buildTypeSpecificRows(),

        const SizedBox(height: 10),
        const Divider(height: 1, color: kRequestViewDividerColor),
        const SizedBox(height: 10),

        // Reason Field
        buildRequestViewDataRow(
          'Reason',
          (reason != null && reason!.isNotEmpty) ? reason! : '--',
        ),

        const SizedBox(height: 10),
        const Divider(height: 1, color: kRequestViewDividerColor),
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
                    locationTitle:
                        locationTitle ?? 'My Location is Around Here:',
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
      ],
    );
  }
}
