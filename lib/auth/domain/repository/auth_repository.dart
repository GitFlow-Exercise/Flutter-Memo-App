import 'package:flutter/foundation.dart';
import 'package:mongo_ai/auth/domain/model/auth_state_change.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository extends ChangeNotifier {
  bool get isAuthenticated;

  bool get isInitialSetupUser;

  bool get isSelectTeam;

  String? get userId;

  Stream<AuthState> get authStateChanges;

  Future<Result<void, AppException>> handleGoogleSignIn(User? user);

  bool checkMetadata(String key);

  Future<Result<void, AppException>> signIn(String email, String password);

  Future<Result<void, AppException>> signInWithGoogle();

  Future<Result<void, AppException>> signUp(String email, String password);

  Future<Result<void, AppException>> signOut();

  Future<Result<void, AppException>> deleteUser(String id);

  Future<Result<bool, AppException>> isEmailExist(String email);

  Future<Result<void, AppException>> saveUser();

  Future<Result<void, AppException>> sendOtp(String email);

  Future<Result<void, AppException>> verifyEmailOtp(String email, String otp);

  Future<Result<void, AppException>> verifyMagicLinkOtp(
    String email,
    String otp,
  );

  Future<Result<void, AppException>> resetPassword(String password);

  Future<Result<String, AppException>> getCurrentUserEmail();

  Future<Result<void, AppException>> setSelectTeamMetadata();

  // 인증 Provider 정보 반환
  String? getUserProvider();

  void addAuthStateListener(void Function(AuthStateChange) listener);

  void removeAuthStateListener(void Function(AuthStateChange) listener);
}
