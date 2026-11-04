import '../entities/personal_profile.dart';
import '../repositories/personal_repository.dart';

/// Usecase for retrieving user personal profile.
class GetPersonalProfileUseCase {
  final PersonalRepository repository;

  const GetPersonalProfileUseCase(this.repository);

  Future<PersonalProfile> execute() {
    return repository.getProfile();
  }
}
