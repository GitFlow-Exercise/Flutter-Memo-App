import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_password_event.freezed.dart';

@freezed
sealed class SignUpPasswordEvent with _$SignUpPasswordEvent {
  const factory SignUpPasswordEvent.showSnackBar(String message) = ShowSnackBar;

  const factory SignUpPasswordEvent.navigateToComplete() = NavigateToComplete;
}
