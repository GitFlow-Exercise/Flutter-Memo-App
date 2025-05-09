import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';
import 'package:mongo_ai/dashboard/domain/model/user_profile.dart';

part 'dashboard_view_model.g.dart';

class DashboardData {
  final Result<UserProfile, AppException> userProfileResult;
  final Result<List<Team>, AppException> teamsResult;

  DashboardData({
    required this.userProfileResult,
    required this.teamsResult,
  });
}

@riverpod
class DashboardViewModel extends _$DashboardViewModel {

  @override
  Future<DashboardData> build() async {
    final userProfileResult = await ref.watch(getCurrentUserProfileProvider.future);
    final teamsResult   = await ref.watch(getTeamsByCurrentUserProvider.future);
    return DashboardData(
      userProfileResult: userProfileResult,
      teamsResult: teamsResult,
    );
  }

  Future<void> refreshAll() async {
    // 1) 로딩 상태로 전환
    state = const AsyncLoading();

    // 2) 캐시 비우기
    ref.invalidate(getCurrentUserProfileProvider);
    ref.invalidate(getTeamsByCurrentUserProvider);

    // 3) build() 를 다시 호출 -> 새로 요청된 Future 로딩
    state = await AsyncValue.guard(() => build());
  }
}