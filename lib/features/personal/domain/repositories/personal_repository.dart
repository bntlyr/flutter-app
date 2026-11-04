import '../entities/personal_profile.dart';

/// Contract for Personal profile repository operations.
abstract class PersonalRepository {
  Future<PersonalProfile> getProfile();
}
