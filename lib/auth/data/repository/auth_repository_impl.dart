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
      return Result.error(
        AppException.unknown(
          message: '이메일 또는 비밀번호가 일치하지 않습니다.',
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
  Future<Result<void, AppException>> signInWithGoogle() async {
    try {
      await _authDataSource.signInWithGoogle();
      // 로그인 성공
      notifyListeners();
      return const Result.success(null);
    } on AuthException catch (e) {
      return Result.error(
        AppException.unknown(
          message: '이메일 또는 비밀번호가 일치하지 않습니다.',
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
  Future<Result<void, AppException>> deleteUser(String id) async {
    try {
      await _authDataSource.deleteUser(id);
      notifyListeners();
      return const Result.success(null);
    } catch (e) {
      // 기타 예외 (네트워크, 파싱 등)
      return Result.error(
        AppException.unknown(
          message: '유저를 삭제하던 중 오류가 발생했습니다.',
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
      await _authDataSource.signUp(email, password);

      return const Result.success(null);
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
  Future<Result<void, AppException>> saveUser() async {
    try {
      if (!isAuthenticated) {
        return Result.error(
          AppException.unAuthorized(
            message: '인증되지 않은 사용자입니다.',
            error: null,
            stackTrace: StackTrace.current,
          ),
        );
      }

      await _authDataSource.saveUser();

      // 메타데이터 업데이트
      await _authDataSource.updateUserMetadata('is_initial_setup_user');
      notifyListeners();
      return const Result.success(null);
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
  Future<Result<void, AppException>> resetPassword(String password) async {
    try {
      if (!isAuthenticated) {
        return Result.error(
          AppException.unAuthorized(
            message: '인증되지 않은 사용자입니다.',
            error: null,
            stackTrace: StackTrace.current,
          ),
        );
      }

      final userResponse = await _authDataSource.resetPassword(password);
      if (userResponse.user == null) {
        return Result.error(
          AppException.unknown(
            message: '비밀번호 설정에 실패하였습니다.',
            error: null,
            stackTrace: StackTrace.current,
          ),
        );
      }
      return const Result.success(null);
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
  Future<Result<void, AppException>> sendOtp(String email) async {
    try {
      await _authDataSource.sendOtp(email);
      return const Result.success(null);
    } catch (e) {
      return Result.error(
        AppException.unknown(
          message: '인증번호 전송을 실패하였습니다.',
          error: e,
          stackTrace: StackTrace.current,
        ),
      );
    }
  }

  @override
  Future<Result<void, AppException>> verifyEmailOtp(String email, String otp) async {
    try {
      await _authDataSource.verifyEmailOtp(email, otp);

      return const Result.success(null);
    } catch (e) {
      return Result.error(
        AppException.unknown(
          message: '인증번호가 일치하지 않습니다.',
          error: e,
          stackTrace: StackTrace.current,
        ),
      );
    }
  }

  @override
  Future<Result<void, AppException>> verifyMagicLinkOtp(String email, String otp) async {
    try {
      await _authDataSource.verifyMagicLinkOtp(email, otp);

      return const Result.success(null);
    } catch (e) {
      return Result.error(
        AppException.unknown(
          message: '인증번호가 일치하지 않습니다.',
          error: e,
          stackTrace: StackTrace.current,
        ),
      );
    }
  }

  @override
  Future<Result<String, AppException>> getCurrentUserEmail() async {
    final user = await _authDataSource.getCurrentUserEmail();

    if (user != null) {
      return Result.success(user);
    } else {
      return Result.error(
        AppException.unknownUser(
          message: '사용자 이메일을 불러오던 중 오류가 발생했습니다.',
          stackTrace: StackTrace.current,
        ),
      );
    }
  }

  @override
  Future<Result<void, AppException>> setSelectTeamMetadata() async {
    try {
      await _authDataSource.updateUserMetadata('is_select_team');
      return const Result.success(null);
    } catch (e) {
      return Result.error(
        AppException.unknown(
          message: 'Metadata를 설정하던 중 오류가 발생했습니다: is_select_team',
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

  @override
  bool get isInitialSetupUser {
    return _authDataSource.isInitialSetupUser();
  }

  @override
  bool get isSelectTeam {
    return _authDataSource.isSelectTeam();
  }

  @override
  String? get userId {
    return _authDataSource.userId();
  }

  @override
  bool checkMetadata(String key) {
    return _authDataSource.checkMetadata(key);
  }
}
