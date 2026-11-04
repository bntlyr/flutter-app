/// Domain entity for Personal Employee Profile.
class PersonalProfile {
  final String id;
  final String fullName;
  final String age;
  final String jobClass;
  final String loginId;
  final String employeeId;
  final String biometricsNo;
  final String remarks;

  const PersonalProfile({
    required this.id,
    required this.fullName,
    required this.age,
    required this.jobClass,
    required this.loginId,
    required this.employeeId,
    required this.biometricsNo,
    required this.remarks,
  });
}
