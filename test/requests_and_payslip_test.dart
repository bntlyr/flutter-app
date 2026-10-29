import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/core/utils/app_formatters.dart';
import 'package:flutter_app/data/mock/mock_requests_data.dart';
import 'package:flutter_app/data/models/request_model.dart';
import 'package:flutter_app/data/mock/mock_payslip_data.dart';
import 'package:flutter_app/data/models/payslip_model.dart';

void main() {
  group('AppFormatters unit tests', () {
    test('formats positive and negative currency correctly', () {
      expect(AppFormatters.currency(3450.00), equals('\$3,450.00'));
      expect(AppFormatters.currency(0.0), equals('\$0.00'));
      expect(AppFormatters.currency(-125.50), equals('-\$125.50'));
    });

    test('formats dates correctly', () {
      final date = DateTime(2026, 10, 29);
      expect(AppFormatters.dateShort(date), equals('Oct 29, 2026'));
      expect(AppFormatters.dateWithDay(date), contains('Oct 29, 2026'));
    });
  });

  group('MockRequestsRepository reactive tests', () {
    test('can add a new request and cancel pending request', () {
      final repo = MockRequestsRepository();
      final initialCount = repo.requests.length;

      final newReq = UserRequest(
        id: 'REQ-TEST-001',
        type: RequestType.overtime,
        filingDate: DateTime.now(),
        title: 'Unit Test Overtime',
        description: 'Testing request state',
        status: RequestStatus.pending,
        approver: 'Jane Cooper',
      );

      repo.addRequest(newReq);
      expect(repo.requests.length, equals(initialCount + 1));
      expect(repo.requests.first.id, equals('REQ-TEST-001'));
      expect(repo.requests.first.status, equals(RequestStatus.pending));

      // Test cancelling
      repo.cancelRequest('REQ-TEST-001');
      final cancelled = repo.requests.firstWhere((r) => r.id == 'REQ-TEST-001');
      expect(cancelled.status, equals(RequestStatus.cancelled));
    });
  });

  group('MockPayslipData integrity tests', () {
    test('contains all 8 required breakdown categories', () {
      final payslip = MockPayslipData.cutoffPayslips.values.first;
      for (final cat in PayrollCategory.values) {
        expect(payslip.categoryBreakdown.containsKey(cat), isTrue,
            reason: 'Missing category breakdown for ${cat.displayName}');
      }
    });
  });
}
