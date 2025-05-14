import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mongo_ai/auth/presentation/select_team/controller/select_team_event.dart';
import 'package:mongo_ai/auth/presentation/select_team/controller/select_team_state.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/state/current_team_id_state.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'select_team_view_model.g.dart';

@riverpod
class SelectTeamViewModel extends _$SelectTeamViewModel {
  final _eventController = StreamController<SelectTeamEvent>();
  Stream<SelectTeamEvent> get eventStream => _eventController.stream;

  @override
  SelectTeamState build() {
    final teamNameController = TextEditingController();

    ref.onDispose(() {
      _eventController.close();
      teamNameController.dispose();
    });

    // 초기 상태 생성
    return SelectTeamState(teamNameController: teamNameController);
  }

  // 비동기적으로 팀 목록을 로드하는 함수
  Future<void> loadTeams() async {
    state = state.copyWith(teams: const AsyncValue.loading());

    try {
      // 팀 목록 가져오기
      final teamsProvider = ref.read(getTeamsByCurrentUserProvider.future);
      final result = await teamsProvider;

      switch (result) {
        case Success(data: final teams):
          state = state.copyWith(teams: AsyncValue.data(teams));
        case Error(error: final error):
          state = state.copyWith(
            teams: AsyncValue.error(error, error.stackTrace ?? StackTrace.current),
          );
          _eventController.add(SelectTeamEvent.showSnackBar(error.userFriendlyMessage));
      }
    } catch (e, stack) {
      // 프로바이더 없는 경우 임시 데이터 사용 (데모 목적)
      state = state.copyWith(
          teams: AsyncValue.data([
            const Team(teamId: 1, teamName: "영어선생님 모임", teamImage: null),
            const Team(teamId: 2, teamName: "수학교사 연구회", teamImage: null),
            const Team(teamId: 3, teamName: "K고등학교 교사회", teamImage: null),
          ])
      );
    }
  }

  void selectTeam(Team team) {
    state = state.copyWith(selectedTeam: team);
  }

  void toggleCreateNewTeam() {
    state = state.copyWith(
      isCreatingNewTeam: !state.isCreatingNewTeam,
      selectedTeam: null,
    );
  }

  void updateTeamName(String name) {
    state = state.copyWith(newTeamName: name);
  }

  void createTeam() {
    // 실제 구현에서는 팀 생성 API 호출 필요
    // 여기서는 데모로만 구현
    final newTeamName = state.teamNameController.text.trim();

    if (newTeamName.isEmpty) {
      _eventController.add(const SelectTeamEvent.showSnackBar('팀 이름을 입력해주세요'));
      return;
    }

    final newTeam = Team(
      teamId: DateTime.now().millisecondsSinceEpoch,
      teamName: newTeamName,
      teamImage: null,
    );

    // 실제 API 연동 없이 로컬에서 팀 선택
    state = state.copyWith(
      selectedTeam: newTeam,
      isCreatingNewTeam: false,
      teamNameController: TextEditingController(),
    );

    _eventController.add(const SelectTeamEvent.showSnackBar('새 팀이 생성되었습니다'));
  }

  void confirmTeamSelection() {
    final selectedTeam = state.selectedTeam;

    if (selectedTeam == null) {
      _eventController.add(const SelectTeamEvent.showSnackBar('팀을 선택하거나 생성해주세요'));
      return;
    }

    // 현재 선택된 팀 ID 설정
    ref.read(currentTeamIdStateProvider.notifier).set(selectedTeam.teamId);

    // 이벤트 발행 - "confirmSuccess" 이벤트를 추가
    _eventController.add(const SelectTeamEvent.confirmSuccess());
  }
}