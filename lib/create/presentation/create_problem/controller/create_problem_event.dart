import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_problem_event.freezed.dart';

@freezed
sealed class CreateProblemEvent with _$CreateProblemEvent {
  const factory CreateProblemEvent.showSnackBar(String message) = ShowSnackBar;
}
