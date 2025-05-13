import 'package:mongo_ai/auth/data/data_source/temp_storage_data_source.dart';
import 'package:mongo_ai/auth/data/mapper/retrieve/temp_user_mapper.dart';
import 'package:mongo_ai/auth/domain/model/temp_user.dart';
import 'package:mongo_ai/auth/domain/repository/temp_storage_repository.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';

class TempStorageRepositoryImpl implements TempStorageRepository {
  final TempStorageDataSource _dataSource;

  const TempStorageRepositoryImpl({required TempStorageDataSource dataSource})
    : _dataSource = dataSource;

  @override
  String storeData(TempUser data) {
    return _dataSource.store(data);
  }

  @override
  Result<TempUser, AppException> retrieveData(String id) {
    try {
      final data = _dataSource.retrieve(id);
      if (data == null) {
        return Result.error(
          AppException.tempStore(
            message: '임시 데이터를 찾을 수 없습니다.',
            stackTrace: StackTrace.current,
          ),
        );
      }
      return Result.success(data.toTempUser());
    } catch (e) {
      return Result.error(
        AppException.tempStore(
          message: '임시 데이터 조회 중 오류가 발생했습니다.',
          error: e,
          stackTrace: StackTrace.current,
        ),
      );
    }
  }

  @override
  void removeData(String id) {
    _dataSource.remove(id);
  }

  @override
  void clearAll() {
    _dataSource.clear();
  }
}
