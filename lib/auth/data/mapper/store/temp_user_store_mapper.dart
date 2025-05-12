import 'package:mongo_ai/auth/data/dto/temp_user_dto.dart';
import 'package:mongo_ai/auth/domain/model/temp_user.dart';

extension TempUserStoreMapper on TempUser {
  TempUserDto toTempUserDto() {
    return TempUserDto(
      email: email,
      password: password,
    );
  }
}