import 'package:mongo_ai/dashboard/data/dto/user_profile_dto.dart';
import 'package:mongo_ai/dashboard/domain/model/user_profile.dart';

extension UserProfileMapper on UserProfileDto {
  UserProfile toUserProfile() {
    return UserProfile(
      userId: userId ?? '',
      userName: userName ?? '',
      userImage: userImage,
    );
  }
}