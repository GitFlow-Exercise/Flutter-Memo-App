import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_profile_event.freezed.dart';

@freezed
sealed class MyProfileEvent with _$MyProfileEvent {
  const factory MyProfileEvent.showSnackBar(String message) = ShowSnackBar;

  const factory MyProfileEvent.navigateSignIn() = NavigateSignIn;
}
