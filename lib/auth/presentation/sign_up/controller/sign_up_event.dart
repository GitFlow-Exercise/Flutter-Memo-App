import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_event.freezed.dart';

@freezed
sealed class SignUpEvent with _$SignUpEvent {
  const factory SignUpEvent.showSnackBar(String message) = ShowSnackBar;
  const factory SignUpEvent.navigateToCheckOtp(String email) = NavigateToCheckOtp;
}
