import 'package:mongo_ai/auth/domain/model/temp_user.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';

abstract interface class TempStorageRepository {
  /// 데이터 저장 후 식별자 반환
  String storeData(TempUser data);

  /// 식별자로 데이터 조회
  Result<TempUser, AppException> retrieveData(String id);

  /// 데이터 삭제
  void removeData(String id);

  /// 모든 임시 데이터 삭제
  void clearAll();
}