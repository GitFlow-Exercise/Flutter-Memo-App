import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_complete_action.freezed.dart';

@freezed
sealed class SignUpCompleteAction with _$SignUpCompleteAction {
  const factory SignUpCompleteAction.onTapHome() = OnTapHome;
}