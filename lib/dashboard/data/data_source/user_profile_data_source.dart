import 'package:mongo_ai/dashboard/data/dto/user_profile_dto.dart';
import 'package:mongo_ai/dashboard/domain/model/user_profile.dart';

abstract interface class UserProfileDataSource {
  Future<UserProfileDto> getCurrentUserProfile();
}