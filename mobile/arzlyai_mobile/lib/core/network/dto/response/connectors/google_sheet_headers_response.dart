class GoogleSheetHeadersResponse {
  const GoogleSheetHeadersResponse({required this.headers});

  factory GoogleSheetHeadersResponse.fromJson(Map<String, dynamic> json) {
    return GoogleSheetHeadersResponse(
      headers: (json['headers'] as List<dynamic>)
          .map((value) => value as String)
          .toList(growable: false),
    );
  }

  final List<String> headers;
}
