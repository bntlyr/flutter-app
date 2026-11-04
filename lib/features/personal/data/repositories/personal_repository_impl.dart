import '../../domain/entities/personal_profile.dart';
import '../../domain/repositories/personal_repository.dart';
import '../datasources/personal_remote_datasource.dart';

/// Implementation of PersonalRepository.
class PersonalRepositoryImpl implements PersonalRepository {
  final PersonalRemoteDataSource remoteDataSource;

  PersonalRepositoryImpl({PersonalRemoteDataSource? remoteDataSource})
      : remoteDataSource = remoteDataSource ?? PersonalRemoteDataSourceImpl();

  @override
  Future<PersonalProfile> getProfile() async {
    final emp = await remoteDataSource.getProfile();
    return PersonalProfile(
      id: emp.employeeId,
      fullName: emp.fullName,
      age: emp.age,
      jobClass: emp.jobClass,
      loginId: emp.loginId,
      employeeId: emp.employeeId,
      biometricsNo: emp.biometricsNo,
      remarks: emp.remarks,
    );
  }
}
