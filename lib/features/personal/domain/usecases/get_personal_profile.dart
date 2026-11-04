import 'package:flutter_app/shared/models/profile_model.dart';
import '../repositories/personal_repository.dart';

/// UseCase to fetch the authenticated user's employee profile.
class GetPersonalProfileUseCase {
  final PersonalRepository repository;

  const GetPersonalProfileUseCase(this.repository);

  Future<EmployeeProfile> execute() {
    return repository.getProfile();
  }
}
