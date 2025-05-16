import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state_change.freezed.dart';

@freezed
sealed class AuthStateChange with _$AuthStateChange {
  // 일반 로그인 성공
  const factory AuthStateChange.signedIn() = SignedIn;

  // 로그아웃
  const factory AuthStateChange.signedOut() = SignedOut;

  // Google 로그인 성공 (첫 로그인 여부 포함)
  const factory AuthStateChange.signedInWithGoogle({
    required bool hasTeamNotSelected,
  }) = SignedInWithGoogle;

  // 로그인 실패
  const factory AuthStateChange.signInFailed({
    required String message,
  }) = SignInFailed;
}