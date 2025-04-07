class YconicResponse<T> {
  final List<T> data;
  final bool isSuccess;
  final int statusCode;
  final dynamic errors;
  final int? successCount;
  final int? errorCount;

  YconicResponse({
    required this.data,
    required this.isSuccess,
    required this.statusCode,
    this.errors,
    this.successCount,
    this.errorCount,
  });

  factory YconicResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) parseItem,
  ) {
    final dataList = (json['data'] as List)
        .map((e) => parseItem(e as Map<String, dynamic>))
        .toList();

    return YconicResponse(
      data: dataList,
      isSuccess: json['isSuccess'] as bool,
      statusCode: json['statusCode'] as int,
      errors: json['errors'],
      successCount: json['successCount'] as int?,
      errorCount: json['errorCount'] as int?,
    );
  }
}
