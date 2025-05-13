import 'package:mongo_ai/auth/data/dto/temp_user_dto.dart';
import 'package:mongo_ai/auth/domain/model/temp_user.dart';

abstract interface class TempStorageDataSource {
  /// 데이터 저장 후 식별자 반환
  String store(TempUser data);

  /// 식별자로 데이터 조회
  TempUserDto? retrieve(String id);

  /// 데이터 삭제
  void remove(String id);

  /// 모든 임시 데이터 삭제
  void clear();
}