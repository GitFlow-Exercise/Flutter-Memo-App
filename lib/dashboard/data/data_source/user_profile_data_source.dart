import 'package:mongo_ai/dashboard/domain/model/user_profile.dart';

abstract interface class UserProfileDataSource {
  Future<UserProfile> getCurrentUserProfile();
}