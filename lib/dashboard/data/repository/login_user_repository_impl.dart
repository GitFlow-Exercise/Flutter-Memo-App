import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/data/data_source/login_user_data_source.dart';
import 'package:mongo_ai/dashboard/domain/model/login_user.dart';
import 'package:mongo_ai/dashboard/domain/repository/login_user_repository.dart';

class LoginUserRepositoryImpl implements LoginUserRepository {
  final LoginUserDataSource _dataSource;

  const LoginUserRepositoryImpl({
    required LoginUserDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<Result<LoginUser, AppException>> getCurrentLoginUser() async {
    try {
      final user = await _dataSource.getCurrentLoginUser();
      return Result.success(user);
    } catch(e) {
      return Result.error(
        AppException.remoteDataBase(
          message: '유저 정보를 가져오는 중 오류가 발생했습니다.',
          error: e,
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
}