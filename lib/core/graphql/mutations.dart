/// GraphQL Mutation documents for PayrollNeo Portal.
class GraphQLMutations {
  static const String timeInMutation = r'''
    mutation TimeIn($latitude: Float!, $longitude: Float!, $address: String) {
      timeIn(input: { latitude: $latitude, longitude: $longitude, address: $address }) {
        success
        timestamp
        recordId
      }
    }
  ''';

  static const String timeOutMutation = r'''
    mutation TimeOut($latitude: Float!, $longitude: Float!, $address: String) {
      timeOut(input: { latitude: $latitude, longitude: $longitude, address: $address }) {
        success
        timestamp
        recordId
      }
    }
  ''';
}
