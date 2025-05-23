import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/state/current_team_id_state.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/controller/my_profile_action.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/controller/my_profile_view_model.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/screen/my_profile_screen.dart';

class MyProfileScreenRoot extends ConsumerStatefulWidget {
  const MyProfileScreenRoot({super.key});

  @override
  ConsumerState<MyProfileScreenRoot> createState() =>
      _MyProfileScreenRootState();
}

class _MyProfileScreenRootState extends ConsumerState<MyProfileScreenRoot> {
  @override
  void initState() {
    super.initState();

    //TODO(ok): path 접근 가능하게 수정이 되면 프로필 화면 진입 시 대시보드 path 수정 예정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.read(myProfileViewModelProvider.notifier);

      viewModel.fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myProfileViewModelProvider);
    final teamListAsync = ref.watch(getTeamsByCurrentUserProvider);
    final currentTeamId = ref.watch(currentTeamIdStateProvider);

    return Scaffold(
      body: Builder(
        builder: (context) {
          return teamListAsync.when(
            data: (result) {
              final teamList = switch (result) {
                Success(data: final data) => data,
                Error() => <Team>[],
              };
              final selectedTeamName =
                  teamList
                      .firstWhere(
                        (team) => team.teamId == currentTeamId,
                        orElse:
                            () =>
                                const Team(teamId: -1, teamName: '선택된 팀이 없습니다'),
                      )
                      .teamName;
              return MyProfileScreen(
                state: state,
                onAction: _handleAction,
                teamName: selectedTeamName,
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  void _handleAction(MyProfileAction action) {
    final viewModel = ref.read(myProfileViewModelProvider.notifier);

    switch (action) {
      case OnUpdateProfile(name: final name):
        viewModel.updateUserName(name);
        break;
      case OnLogout():
        viewModel.logout();
        break;
      case OnDeleteAccount():
        viewModel.deleteAccount();
        break;
    }
  }
}
