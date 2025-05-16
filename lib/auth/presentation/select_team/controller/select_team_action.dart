import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';

part 'select_team_action.freezed.dart';

@freezed
sealed class SelectTeamAction with _$SelectTeamAction {
  const factory SelectTeamAction.onSelectTeam(Team team) = OnSelectTeam;

  const factory SelectTeamAction.onCreateTeam() = OnCreateTeam;

  const factory SelectTeamAction.onConfirm() = OnConfirm;

  const factory SelectTeamAction.onToggleCreateNewTeam() =
      OnToggleCreateNewTeam;
}
