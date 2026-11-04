import 'package:flutter/material.dart';

import 'request_view_approvals_and_action.dart';
import 'request_view_common.dart';
import 'request_view_details_content.dart';
import 'request_view_status_badge.dart';

export 'request_view_common.dart' show RequestApprovalStatus;

/// Common View Request Dialog matching web-app / mobile reference.
/// Assembles subcomponents from request-view/.
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
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      isDismissible: true,
      enableDrag: true,
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

    return Container(
      constraints: BoxConstraints(
        maxHeight: mediaQuery.size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Drag Handle Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 8, bottom: 6),
            alignment: Alignment.center,
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // 1. Header Bar: [ Details of Request ]  [ X ]
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: kRequestViewHeaderTeal,
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
                  // Pic 2: Status Badge (Circle icon + status text)
                  RequestViewStatusBadge(status: statusEnum),
                  const SizedBox(height: 20),

                  // Pic 3: Request Details Content
                  RequestViewDetailsContent(
                    filingDate: filingDate,
                    typeOfRequest: typeOfRequest,
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
                    locationTitle: locationTitle,
                    locationAddress: locationAddress,
                    latitude: latitude,
                    longitude: longitude,
                  ),

                  // Pic 4: Approvals Section & Cancel Button
                  RequestViewApprovalsAndAction(
                    status: statusEnum,
                    preApprovedBy: preApprovedBy,
                    preApprovedDate: preApprovedDate,
                    approvedBy: approvedBy,
                    approvedDate: approvedDate,
                    rejectedBy: rejectedBy,
                    rejectedDate: rejectedDate,
                    onCancelRequest: onCancelRequest,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
