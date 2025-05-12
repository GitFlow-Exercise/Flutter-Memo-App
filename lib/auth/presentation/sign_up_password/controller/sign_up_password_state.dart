import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_password_state.freezed.dart';

@freezed
abstract class SignUpPasswordState with _$SignUpPasswordState {
  const factory SignUpPasswordState({
    @Default(AsyncValue.data(null)) AsyncValue<dynamic> data,
  }) = _SignUpPasswordState;
}