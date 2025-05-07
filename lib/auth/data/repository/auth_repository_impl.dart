import 'package:mongo_ai/auth/data/data_source/auth_data_source.dart';
import 'package:mongo_ai/auth/domain/repository/auth_repository.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl({required AuthDataSource authDataSource})
    : _authDataSource = authDataSource;

  @override
  Future<Result<void, AppException>> signIn(
    String email,
    String password,
  ) async {
    try {
      await _authDataSource.login(email, password);
      // 로그인 성공
      notifyListeners();
      return const Result.success(null);
    } on AuthException catch (e) {
      // Supabase가 제공하는 메시지를 기반으로 판단
      final msg = e.message.toLowerCase();

      if (msg.contains('email')) {
        return Result.error(
          AppException.invalidEmail(
            message: '유효하지 않은 이메일입니다.',
            error: e,
            stackTrace: StackTrace.current,
          ),
        );
      } else if (msg.contains('password')) {
        return Result.error(
          AppException.invalidPassword(
            message: '유효하지 않은 비밀번호입니다.',
            error: e,
            stackTrace: StackTrace.current,
          ),
        );
      }

      return Result.error(
        AppException.unknown(
          message: '알 수 없는 오류입니다.',
          error: e,
          stackTrace: StackTrace.current,
        ),
      ); // 기타 인증 오류
    } catch (e) {
      // 기타 예외 (네트워크, 파싱 등)
      return Result.error(
        AppException.unknown(
          message: '알 수 없는 오류입니다.',
          error: e,
          stackTrace: StackTrace.current,
        ),
      );
    }
  }

  @override
  Future<Result<void, AppException>> signOut() async {
    try {
      await _authDataSource.logout();
      notifyListeners();
      return const Result.success(null);
    } catch (e) {
      // 기타 예외 (네트워크, 파싱 등)
      return Result.error(
        AppException.unknown(
          message: '알 수 없는 오류입니다.',
          error: e,
          stackTrace: StackTrace.current,
        ),
      );
    }
  }

  @override
  Future<Result<void, AppException>> signUp(
    String email,
    String password,
  ) async {
    try {
      final response = await _authDataSource.signUp(email, password);
      if (response.user != null) {
        // 중복 이메일 처리
        return Result.error(
          AppException.emailAlreadyExist(
            message: '이미 존재하는 이메일입니다.',
            error: const AuthException('이미 존재하는 이메일입니다.'),
            stackTrace: StackTrace.current,
          ),
        );
      } else {
        return const Result.success(null);
      }
    } catch (e) {
      return Result.error(
        AppException.unknown(
          message: '알 수 없는 오류입니다.',
          error: e,
          stackTrace: StackTrace.current,
        ),
      );
    }
  }

  @override
  Future<Result<bool, AppException>> isEmailExist(String email) async {
    try {
      final response = await _authDataSource.isEmailExist(email);

      if (response) {
        return Result.error(
          AppException.emailAlreadyExist(
            message: '이미 존재하는 이메일입니다.',
            error: const AuthException('이미 존재하는 이메일입니다.'),
            stackTrace: StackTrace.current,
          ),
        );
      } else {
        return const Result.success(false);
      }
    } catch (e) {
      return Result.error(
        AppException.unknown(
          message: '알 수 없는 오류입니다.',
          error: e,
          stackTrace: StackTrace.current,
        ),
      );
    }
  }

  @override
  bool get isAuthenticated {
    return _authDataSource.isAuthenticated();
  }
}
