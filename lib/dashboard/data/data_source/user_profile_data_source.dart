import 'package:mongo_ai/dashboard/data/dto/user_profile_dto.dart';

abstract interface class UserProfileDataSource {
  Future<UserProfileDto> getCurrentUserProfile();
}