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

  const factory AppException.remoteDataBase({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) = RemoteDataBaseException;

  const factory AppException.localDataBase({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) = localDataBaseException;

  String get userFriendlyMessage {
    switch (this) {
      case NetworkException():
        return '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
      case RemoteDataBaseException():
      case localDataBaseException():
        return '데이터를 불러오지 못했습니다.';
    }
  }
}
