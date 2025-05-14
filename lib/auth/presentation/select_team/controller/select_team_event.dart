import 'package:freezed_annotation/freezed_annotation.dart';

part 'select_team_event.freezed.dart';

@freezed
sealed class SelectTeamEvent with _$SelectTeamEvent {
  const factory SelectTeamEvent.showSnackBar(String message) = ShowSnackBar;

  const factory SelectTeamEvent.confirmSuccess() = ConfirmSuccess;
}
