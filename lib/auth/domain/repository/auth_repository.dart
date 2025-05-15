import 'package:flutter/foundation.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';

abstract class AuthRepository extends ChangeNotifier {
  bool get isAuthenticated;

  bool get isInitialSetupUser;

  bool get isSelectTeam;

  String? get userId;

  bool checkMetadata(String key);

  Future<Result<void, AppException>> signIn(String email, String password);

  Future<Result<void, AppException>> signInWithGoogle();

  Future<Result<void, AppException>> signUp(String email, String password);

  Future<Result<void, AppException>> signOut();

  Future<Result<bool, AppException>> isEmailExist(String email);

  Future<Result<void, AppException>> saveUser();

  Future<Result<void, AppException>> sendOtp(String email);

  Future<Result<void, AppException>> verifyEmailOtp(String email, String otp);

  Future<Result<void, AppException>> verifyMagicLinkOtp(String email, String otp);

  Future<Result<void, AppException>> resetPassword(String password);

  Future<Result<String, AppException>> getCurrentUserEmail();

  Future<Result<void, AppException>> setSelectTeamMetadata();
}
