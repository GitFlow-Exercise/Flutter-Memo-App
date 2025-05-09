import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/domain/model/user_profile.dart';

abstract interface class UserProfileRepository {
  Future<Result<UserProfile, AppException>> getCurrentUserProfile();
}

