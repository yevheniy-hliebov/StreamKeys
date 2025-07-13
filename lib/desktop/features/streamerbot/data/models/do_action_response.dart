class DoActionResponse {
  final String id;
  final String status;

  DoActionResponse({
    required this.id,
    required this.status,
  });

  factory DoActionResponse.fromJson(Map<String, dynamic> json) {
    return DoActionResponse(
      id: json['id'],
      status: json['status'],
    );
  }
}
