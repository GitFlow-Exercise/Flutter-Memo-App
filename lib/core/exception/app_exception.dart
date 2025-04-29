import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_exception.freezed.dart';

@freezed
sealed class AppException with _$AppException implements Exception {
  const AppException._();

  const factory AppException.network({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) = NetworkException;
}
