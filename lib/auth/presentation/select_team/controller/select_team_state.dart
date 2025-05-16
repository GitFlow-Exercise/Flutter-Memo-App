import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';

part 'select_team_state.freezed.dart';

@freezed
abstract class SelectTeamState with _$SelectTeamState {
  const factory SelectTeamState({
    @Default(AsyncValue.data([])) AsyncValue<List<Team>> teams,
    @Default(null) Team? selectedTeam,
    @Default(false) bool isCreatingNewTeam,
    @Default(null) String? userId,
    required TextEditingController teamNameController,
  }) = _SelectTeamState;
}
