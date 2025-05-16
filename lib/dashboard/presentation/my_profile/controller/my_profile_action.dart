import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_profile_action.freezed.dart';

@freezed
sealed class MyProfileAction with _$MyProfileAction {
  const factory MyProfileAction.onTap() = OnTap;

  const factory MyProfileAction.onUpdateProfile(String name) = OnUpdateProfile;

  const factory MyProfileAction.onLogout() = OnLogout;

  const factory MyProfileAction.onDeleteAccount() = OnDeleteAccount;
}
