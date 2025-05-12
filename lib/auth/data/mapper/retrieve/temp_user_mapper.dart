import 'package:mongo_ai/auth/data/dto/temp_user_dto.dart';
import 'package:mongo_ai/auth/domain/model/temp_user.dart';

extension TempUserMapper on TempUserDto {
  TempUser toTempUser() {
    return TempUser(
      email: email ?? '',
      password: password ?? '',
    );
  }
}