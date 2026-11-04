/// GraphQL Query documents for PayrollNeo Portal.
class GraphQLQueries {
  static const String getEmployeeProfile = r'''
    query GetEmployeeProfile($employeeId: ID!) {
      employee(id: $employeeId) {
        id
        fullName
        age
        jobClass
        loginId
        employeeId
        biometricsNo
        remarks
      }
    }
  ''';

  static const String getAttendanceSummary = r'''
    query GetAttendanceSummary($cutoffId: ID!) {
      attendanceSummary(cutoffId: $cutoffId) {
        approvedRequests
        absent
        late
        undertime
        allowance
      }
    }
  ''';
}
