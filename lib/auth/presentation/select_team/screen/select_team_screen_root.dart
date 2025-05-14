import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/auth/presentation/select_team/controller/select_team_action.dart';
import 'package:mongo_ai/auth/presentation/select_team/controller/select_team_event.dart';
import 'package:mongo_ai/auth/presentation/select_team/controller/select_team_view_model.dart';
import 'package:mongo_ai/auth/presentation/select_team/screen/select_team_screen.dart';
import 'package:mongo_ai/core/routing/routes.dart';

class SelectTeamScreenRoot extends ConsumerStatefulWidget {
  const SelectTeamScreenRoot({super.key});

  @override
  ConsumerState<SelectTeamScreenRoot> createState() =>
      _SelectGroupScreenRootState();
}

class _SelectGroupScreenRootState extends ConsumerState<SelectTeamScreenRoot> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.watch(selectTeamViewModelProvider.notifier);

      _subscription = viewModel.eventStream.listen(_handleEvent);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleEvent(SelectTeamEvent event) {
    switch (event) {
      case ShowSnackBar(message: final message):
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message))
        );
        break;
      case ConfirmSuccess():
      // 홈 화면으로 이동
        context.go(Routes.myFiles);
        break;
    }
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
      case OnChangeTeamName(name: final name):
        viewModel.updateTeamName(name);
        break;
      case OnToggleCreateNewTeam():
        viewModel.toggleCreateNewTeam();
        break;
    }
  }
}