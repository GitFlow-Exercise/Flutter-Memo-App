import 'package:flutter_test/flutter_test.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/domain/model/user_profile.dart';
import 'package:mongo_ai/dashboard/domain/repository/user_profile_repository.dart';
import '../../../core/di/test_di.dart';

void main() {
  late UserProfileRepository userProfileRepository;

  final sampleProfile = const UserProfile(userId: '1', userName: 'userName');

  setUpAll(() {
    mockdDISetup();
    userProfileRepository = mockLocator();
  });

  test('getCurrentUserProfile test', () async {
    final result = await userProfileRepository.getCurrentUserProfile();

    switch (result) {
      case Success<UserProfile, AppException>():
        final profile = result.data;
        expect(profile, isA<UserProfile>());
        expect(profile.userId, equals(sampleProfile.userId));
        expect(profile.userName, equals(sampleProfile.userName));

        break;
      case Error<UserProfile, AppException>():
        expect(result, isA<Error<UserProfile, AppException>>());
        break;
    }
  });
}
