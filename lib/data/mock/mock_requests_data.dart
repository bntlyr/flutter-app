import 'package:flutter/material.dart';
import '../models/request_model.dart';

class MockRequestsRepository extends ChangeNotifier {
  // Singleton pattern for reactive in-app state across views
  static final MockRequestsRepository _instance = MockRequestsRepository._internal();
  factory MockRequestsRepository() => _instance;

  MockRequestsRepository._internal();

  final List<UserRequest> _requests = [
    UserRequest(
      id: 'REQ-2026-0891',
      type: RequestType.leave,
      filingDate: DateTime(2026, 10, 27, 9, 30),
      title: 'Vacation Leave (3 Days)',
      description: 'Annual family vacation leave. Covered Oct 28 - Oct 30, 2026.',
      status: RequestStatus.pending,
      approver: 'Jane Cooper (Lead Manager)',
      metadata: {
        'leaveType': 'Vacation Leave',
        'dates': 'Oct 28 - Oct 30, 2026',
        'days': 3.0,
      },
    ),
    UserRequest(
      id: 'REQ-2026-0884',
      type: RequestType.overtime,
      filingDate: DateTime(2026, 10, 24, 17, 15),
      title: 'Overtime Work (2.5 Hours)',
      description: 'Critical sprint release deployment and performance monitoring.',
      status: RequestStatus.approved,
      approver: 'Robert Fox (Dept Head)',
      reviewedDate: DateTime(2026, 10, 24, 18, 0),
      metadata: {
        'date': 'Oct 24, 2026',
        'hours': 2.5,
      },
    ),
    UserRequest(
      id: 'REQ-2026-0870',
      type: RequestType.timelogsCorrection,
      filingDate: DateTime(2026, 10, 19, 8, 45),
      title: 'Missed Clock-Out Adjustment',
      description: 'Biometrics terminal offline at main gate. Left at 05:00 PM.',
      status: RequestStatus.approved,
      approver: 'Sarah Miller (HR Supervisor)',
      reviewedDate: DateTime(2026, 10, 19, 11, 20),
      metadata: {
        'targetDate': 'Oct 18, 2026',
        'correctedTime': '05:00 PM',
      },
    ),
    UserRequest(
      id: 'REQ-2026-0862',
      type: RequestType.allowance,
      filingDate: DateTime(2026, 10, 15, 14, 0),
      title: 'Client Onsite Transport Allowance',
      description: 'Transport reimbursement for client office security audit.',
      status: RequestStatus.approved,
      approver: 'David Wilson (Finance Director)',
      reviewedDate: DateTime(2026, 10, 16, 10, 0),
      metadata: {
        'amount': 45.0,
        'category': 'Transport & Parking',
      },
    ),
    UserRequest(
      id: 'REQ-2026-0855',
      type: RequestType.dayOffWork,
      filingDate: DateTime(2026, 10, 10, 11, 10),
      title: 'Rest Day Work Request',
      description: 'Emergency cloud server migration on Saturday schedule.',
      status: RequestStatus.approved,
      approver: 'Jane Cooper (Lead Manager)',
      reviewedDate: DateTime(2026, 10, 10, 16, 40),
      metadata: {
        'workDate': 'Oct 12, 2026',
        'compensation': 'Standard Rest Day Overtime Pay',
      },
    ),
    UserRequest(
      id: 'REQ-2026-0840',
      type: RequestType.reshift,
      filingDate: DateTime(2026, 10, 5, 9, 0),
      title: 'Shift Change Request',
      description: 'Request shift adjustment from Morning (08:00 AM) to Mid (10:00 AM) for class.',
      status: RequestStatus.rejected,
      approver: 'Jane Cooper (Lead Manager)',
      reviewedDate: DateTime(2026, 10, 6, 13, 15),
      metadata: {
        'currentShift': '08:00 AM - 05:00 PM',
        'requestedShift': '10:00 AM - 07:00 PM',
        'reason': 'Team core collaboration hours requirement',
      },
    ),
  ];

  List<UserRequest> get requests => List.unmodifiable(_requests);

  void addRequest(UserRequest request) {
    _requests.insert(0, request);
    notifyListeners();
  }

  void cancelRequest(String id) {
    final index = _requests.indexWhere((r) => r.id == id);
    if (index != -1) {
      final existing = _requests[index];
      if (existing.status == RequestStatus.pending) {
        _requests[index] = existing.copyWith(status: RequestStatus.cancelled);
        notifyListeners();
      }
    }
  }
}
