import 'package:supabase_flutter/supabase_flutter.dart';

class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException({
    required this.message,
    this.code,
    this.details,
  });

  factory AppException.fromPostgrest(PostgrestException exception) {
    return AppException(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }

  factory AppException.fromAuth(AuthException exception) {
    return AppException(
      message: exception.message,
      code: exception.statusCode,
    );
  }

  factory AppException.fromException(dynamic e) {
    if (e is PostgrestException) {
      return AppException.fromPostgrest(e);
    } else if (e is AuthException) {
      return AppException.fromAuth(e);
    } else if (e is AppException) {
      return e;
    }
    return AppException(message: e.toString());
  }

  @override
  String toString() => message;
}
