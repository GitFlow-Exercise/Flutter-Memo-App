import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/domain/model/login_user.dart';

abstract interface class LoginUserRepository {
  Future<Result<LoginUser, AppException>> getCurrentLoginUser();
}

