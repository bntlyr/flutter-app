class RequestEntity {
  final String id;
  final String type;
  final String status;
  final String filingDate;
  final String? details;

  const RequestEntity({
    required this.id,
    required this.type,
    required this.status,
    required this.filingDate,
    this.details,
  });
}
