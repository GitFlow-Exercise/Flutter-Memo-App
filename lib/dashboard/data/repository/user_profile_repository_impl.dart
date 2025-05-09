import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/data/data_source/user_profile_data_source.dart';
import 'package:mongo_ai/dashboard/data/mapper/user_profile_mapper.dart';
import 'package:mongo_ai/dashboard/domain/model/user_profile.dart';
import 'package:mongo_ai/dashboard/domain/repository/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileDataSource _dataSource;

  const UserProfileRepositoryImpl({
    required UserProfileDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<Result<UserProfile, AppException>> getCurrentUserProfile() async {
    try {
      final userDto = await _dataSource.getCurrentUserProfile();
      final user = userDto.toUserProfile();
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