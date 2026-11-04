import 'package:flutter_app/data/mock/mock_profile_data.dart';
import 'package:flutter_app/shared/models/profile_model.dart';

/// Remote data source contract for Personal Profile.
abstract class PersonalRemoteDataSource {
  Future<EmployeeProfile> getProfile();
}

class PersonalRemoteDataSourceImpl implements PersonalRemoteDataSource {
  @override
  Future<EmployeeProfile> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockProfileData.profile;
  }
}
