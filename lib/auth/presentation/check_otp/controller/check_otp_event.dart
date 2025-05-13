import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_otp_event.freezed.dart';

@freezed
sealed class CheckOtpEvent with _$CheckOtpEvent {
  const factory CheckOtpEvent.showSnackBar(String message) = ShowSnackBar;
  const factory CheckOtpEvent.navigateToPasswordScreen(String email) =
      NavigateToPasswordScreen;
}
