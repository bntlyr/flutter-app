import '../entities/personal_schedule_entity.dart';
import '../repositories/personal_repository.dart';

/// UseCase to fetch the monthly shift calendar for a user.
class GetPersonalScheduleUseCase {
  final PersonalRepository repository;

  const GetPersonalScheduleUseCase(this.repository);

  Future<List<ShiftDayData>> execute({
    required String userId,
    required DateTime month,
  }) {
    return repository.getSchedule(userId: userId, month: month);
  }
}
