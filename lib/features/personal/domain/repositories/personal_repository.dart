import 'package:flutter_app/shared/models/profile_model.dart';
import '../entities/personal_schedule_entity.dart';

/// Contract for Personal profile and schedule repository operations.
abstract class PersonalRepository {
  Future<EmployeeProfile> getProfile();
  Future<List<ShiftDayData>> getSchedule({
    required String userId,
    required DateTime month,
  });
}
