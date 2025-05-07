import 'package:mongo_ai/dashboard/domain/model/login_user.dart';

abstract interface class LoginUserDataSource {
  Future<LoginUser> getCurrentLoginUser();
}