import 'package:mongo_ai/dashboard/data/data_source/user_profile_data_source.dart';
import 'package:mongo_ai/dashboard/data/dto/user_profile_dto.dart';

class MockUserProfileDataSourceImpl implements UserProfileDataSource {
  MockUserProfileDataSourceImpl();
  final userProfile = UserProfileDto(
    userId: '1',
    userName: 'userName',
    userImage: 'userImage',
  );

  @override
  Future<UserProfileDto> getCurrentUserProfile() async {
    return userProfile;
  }
}
