import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/auth/presentation/select_team/controller/select_team_action.dart';
import 'package:mongo_ai/auth/presentation/select_team/controller/select_team_view_model.dart';
import 'package:mongo_ai/auth/presentation/select_team/screen/select_team_screen.dart';

class SelectTeamScreenRoot extends ConsumerStatefulWidget {
  const SelectTeamScreenRoot({super.key});

  @override
  ConsumerState<SelectTeamScreenRoot> createState() =>
      _SelectGroupScreenRootState();
}

class _SelectGroupScreenRootState extends ConsumerState<SelectTeamScreenRoot> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.read(selectTeamViewModelProvider.notifier);

      // 팀 목록 로드
      viewModel.loadTeams();

      // 유저 아이디 불러오기
      viewModel.fetchUserId();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(selectTeamViewModelProvider);

    return Scaffold(
      body: SelectTeamScreen(state: state, onAction: _handleAction),
    );
  }

  void _handleAction(SelectTeamAction action) {
    final viewModel = ref.read(selectTeamViewModelProvider.notifier);

    switch (action) {
      case OnSelectTeam(team: final team):
        viewModel.selectTeam(team);
        break;
      case OnCreateTeam():
        viewModel.createTeam();
        break;
      case OnConfirm():
        viewModel.confirmTeamSelection();
        break;
      case OnToggleCreateNewTeam():
        viewModel.toggleCreateNewTeam();
        break;
      case OnCancel():
        viewModel.cancelTeamSelect();
        break;
    }
  }
}
