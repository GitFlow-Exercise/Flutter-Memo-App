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

    // 초기 로딩 시 사용자 ID 가져오기
    _fetchUserId();

    return SelectTeamState(
      teamNameController: teamNameController,
      userId: null,
    );
  }

  // 사용자 ID 가져오기
  Future<void> _fetchUserId() async {
    final authRepository = ref.read(authRepositoryProvider);
    final userId = authRepository.userId;

    if (userId != null) {
      state = state.copyWith(userId: userId);
      debugPrint('현재 사용자 ID: $userId');
    } else {
      _eventController.add(
        const SelectTeamEvent.showSnackBar('사용자 정보를 가져올 수 없습니다'),
      );
    }
  }

  // 팀 목록을 가져오는 메서드
  Future<void> loadTeams() async {
    state = state.copyWith(teams: const AsyncValue.loading());

    final teamRepository = ref.read(teamRepositoryProvider);
    final result = await teamRepository.getAllTeams();

    switch (result) {
      case Success(data: final teams):
        state = state.copyWith(teams: AsyncValue.data(teams));
      case Error(error: final error):
        state = state.copyWith(
          teams: AsyncValue.error(
            error,
            error.stackTrace ?? StackTrace.current,
          ),
        );
        _eventController.add(
          SelectTeamEvent.showSnackBar(error.userFriendlyMessage),
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

  Future<void> createTeam() async {
    final newTeamName = state.teamNameController.text.trim();

    if (newTeamName.isEmpty) {
      _eventController.add(const SelectTeamEvent.showSnackBar('팀 이름을 입력해주세요'));
      return;
    }

    final teamRepository = ref.read(teamRepositoryProvider);
    final result = await teamRepository.createTeam(newTeamName, null);

    switch (result) {
      case Success(data: final newTeam):
      // 팀 목록에 새로 생성된 팀 추가 및 선택
        final currentTeams = state.teams.value ?? [];
        state = state.copyWith(
          teams: AsyncValue.data([...currentTeams, newTeam]),
          selectedTeam: newTeam,
          isCreatingNewTeam: false,
        );
        // 컨트롤러 초기화
        state.teamNameController.clear();
        _eventController.add(
          const SelectTeamEvent.showSnackBar('새 팀이 생성되었습니다'),
        );
      case Error(error: final error):
        _eventController.add(
          SelectTeamEvent.showSnackBar(error.userFriendlyMessage),
        );
    }
  }

  Future<void> confirmTeamSelection() async {
    final selectedTeam = state.selectedTeam;
    final userId = state.userId;

    if (selectedTeam == null) {
      _eventController.add(
        const SelectTeamEvent.showSnackBar('팀을 선택하거나 생성해주세요'),
      );
      return;
    }

    if (userId == null) {
      _eventController.add(
        const SelectTeamEvent.showSnackBar('사용자 정보를 가져올 수 없습니다'),
      );
      return;
    }

    // 사용자를 팀에 할당
    final teamRepository = ref.read(teamRepositoryProvider);
    final assignResult = await teamRepository.assignUserToTeam(
      userId,
      selectedTeam.teamId,
    );

    switch (assignResult) {
      case Success():
      // 현재 선택된 팀 ID 설정
        ref.read(currentTeamIdStateProvider.notifier).set(selectedTeam.teamId);

        // 초기 설정 완료 메타데이터 저장
        final authRepository = ref.read(authRepositoryProvider);
        final metadataResult = await authRepository.setSelectTeamMetadata();

        switch (metadataResult) {
          case Success():
            debugPrint(
              '초기 팀 설정 완료: 팀 ID ${selectedTeam.teamId}, 팀 이름 ${selectedTeam.teamName}',
            );
            // 이벤트 발행 - "confirmSuccess" 이벤트를 추가
            _eventController.add(const SelectTeamEvent.confirmSuccess());
          case Error(error: final error):
            _eventController.add(
              SelectTeamEvent.showSnackBar(error.userFriendlyMessage),
            );
        }
      case Error(error: final error):
        _eventController.add(
          SelectTeamEvent.showSnackBar(error.userFriendlyMessage),
        );
    }
  }
}