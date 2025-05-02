import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/home/data/data_source/home_data_source.dart';
import 'package:mongo_ai/home/data/mapper/home_mapper.dart';
import 'package:mongo_ai/home/domain/model/home.dart';
import 'package:mongo_ai/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource _homeDataSource;

  const HomeRepositoryImpl({required HomeDataSource homeDataSource})
    : _homeDataSource = homeDataSource;

  @override
  Future<Result<Home, AppException>> getHomeInfo() async {
    try {
      final homeDto = await _homeDataSource.getHomeInfo();
      return Result.success(homeDto.toHome());
    } catch (e) {
      return Result.error(
        AppException.network(
          message: '홈 정보를 가져오는 중 오류가 발생했습니다.',
          error: e,
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
}
