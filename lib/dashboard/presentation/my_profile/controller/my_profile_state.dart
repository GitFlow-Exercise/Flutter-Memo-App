import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/dashboard/domain/model/user_profile.dart';

part 'my_profile_state.freezed.dart';

@freezed
abstract class MyProfileState with _$MyProfileState {
  const factory MyProfileState({
    @Default(AsyncValue.loading()) AsyncValue<UserProfile> data,
    required TextEditingController userNameController,
  }) = _MyProfileState;
}
