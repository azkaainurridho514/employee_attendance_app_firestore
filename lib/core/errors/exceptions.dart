class ServerException implements Exception {
  final String message;
  final int? code;

  const ServerException({required this.message, this.code});
}

class CacheException implements Exception {
  final String message;
  final int? code;

  const CacheException({required this.message, this.code});
}
