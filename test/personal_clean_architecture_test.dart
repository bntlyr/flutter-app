import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/data/mock/mock_profile_data.dart';
import 'package:flutter_app/features/personal/domain/entities/personal_schedule_entity.dart';
import 'package:flutter_app/features/personal/domain/repositories/personal_repository.dart';
import 'package:flutter_app/features/personal/domain/usecases/get_personal_profile.dart';
import 'package:flutter_app/features/personal/domain/usecases/get_personal_schedule.dart';
import 'package:flutter_app/features/personal/presentation/viewmodels/personal_viewmodel.dart';
import 'package:flutter_app/features/personal/presentation/viewmodels/personal_schedule_viewmodel.dart';
import 'package:flutter_app/features/personal/data/models/personal_model.dart';
import 'package:flutter_app/shared/models/profile_model.dart';

class _MockPersonalRepository implements PersonalRepository {
  @override
  Future<EmployeeProfile> getProfile() async {
    return MockProfileData.profile;
  }

  @override
  Future<List<ShiftDayData>> getSchedule({
    required String userId,
    required DateTime month,
  }) async {
    return [
      ShiftDayData(
        date: DateTime(month.year, month.month, 1),
        isCurrentMonth: true,
        classification: ShiftClassification.regular,
        title: 'Regular Shift',
        timeRange: '08:00 – 17:00 [ 8.0 hrs. ]',
      ),
    ];
  }
}

class _FailingPersonalRepo implements PersonalRepository {
  @override
  Future<EmployeeProfile> getProfile() async => throw Exception('offline');
  @override
  Future<List<ShiftDayData>> getSchedule({required String userId, required DateTime month}) async =>
      throw Exception('offline');
}

void main() {
  group('Personal Clean Architecture Tests', () {
    late _MockPersonalRepository repository;

    setUp(() {
      repository = _MockPersonalRepository();
    });

    test('PersonalViewModel loads profile and notifies listeners', () async {
      final useCase = GetPersonalProfileUseCase(repository);
      final viewModel = PersonalViewModel(getProfileUseCase: useCase);

      expect(viewModel.profile, isNull);
      await viewModel.loadProfile();

      expect(viewModel.profile, isNotNull);
      expect(viewModel.profile!.fullName, equals('Paul Javinez'));
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.hasError, isFalse);
    });

    test('PersonalScheduleViewModel loads schedule and selects date', () async {
      final useCase = GetPersonalScheduleUseCase(repository);
      final initialMonth = DateTime(2026, 11, 1);
      final viewModel = PersonalScheduleViewModel(
        getScheduleUseCase: useCase,
        initialMonth: initialMonth,
      );

      await viewModel.loadSchedule(userId: 'test_user');

      expect(viewModel.days.length, equals(1));
      expect(viewModel.selectedDayData, isNotNull);
      expect(viewModel.selectedDayData!.title, equals('Regular Shift'));

      viewModel.selectDate(DateTime(2026, 11, 2));
      expect(viewModel.selectedDate, equals(DateTime(2026, 11, 2)));
    });

    test('PersonalScheduleViewModel fallback highlights active cutoff vs other cutoff', () async {
      final viewModel = PersonalScheduleViewModel(
        getScheduleUseCase: GetPersonalScheduleUseCase(_FailingPersonalRepo()),
        initialMonth: DateTime(2026, 11, 1),
      );

      await viewModel.loadSchedule(userId: 'test_user');

      expect(viewModel.days.isNotEmpty, isTrue);

      // Verify weekends are rest days
      final sunDay = viewModel.days.firstWhere((d) => d.date.weekday == DateTime.sunday);
      expect(sunDay.classification, equals(ShiftClassification.restDay));

      // Nov 2, 2026 is Monday inside Nov 1-15 active cutoff
      final nov2 = viewModel.days.firstWhere((d) => d.date.year == 2026 && d.date.month == 11 && d.date.day == 2);
      expect(nov2.classification, equals(ShiftClassification.regular));

      // Nov 16, 2026 is Monday outside active cutoff (16-30)
      final nov16 = viewModel.days.firstWhere((d) => d.date.year == 2026 && d.date.month == 11 && d.date.day == 16);
      expect(nov16.classification, equals(ShiftClassification.otherCutOffs));
    });

    test('MockProfileData entitlements match web-app structure and labels', () {
      final entitlements = MockProfileData.profile.entitlements;

      expect(entitlements.length, equals(5));
      expect(entitlements[0].primaryLabel, equals('Time Sheet Required'));
      expect(entitlements[0].secondaryLabel, equals('Flexitime'));
      expect(entitlements[1].primaryLabel, equals('Unworked Regular Holiday Pay'));
      expect(entitlements[1].secondaryLabel, equals('Unworked Special Holiday Pay'));
      expect(entitlements[2].primaryLabel, equals('Rest Day Pay'));
      expect(entitlements[2].secondaryLabel, equals('Holiday Premium Pay'));
      expect(entitlements[3].primaryLabel, equals('Night Differential Pay'));
      expect(entitlements[3].secondaryLabel, equals('Overtime Pay'));
      expect(entitlements[4].primaryLabel, equals('Night Differential Pay'));
      expect(entitlements[4].secondaryLabel, equals('Overtime Pay'));
    });
  });
}
