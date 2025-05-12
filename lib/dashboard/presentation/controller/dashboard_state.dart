import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';
import 'package:mongo_ai/dashboard/domain/model/user_profile.dart';

part 'dashboard_state.freezed.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    required UserProfile userProfile,
    int? currentTeamId,
  }) = _DashboardState;
}