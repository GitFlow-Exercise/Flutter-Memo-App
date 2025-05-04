import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';

abstract interface class AuthRepository {
  Future<Result<void, AppException>> signIn(String email, String password);
  Future<Result<void, AppException>> signUp(String email, String password);
  Future<Result<void, AppException>> signOut();
  Future<Result<bool, AppException>> isEmailExist(String email);
}
