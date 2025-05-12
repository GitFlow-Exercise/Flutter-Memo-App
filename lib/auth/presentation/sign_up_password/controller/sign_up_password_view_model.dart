import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_event.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_password_view_model.g.dart';

@riverpod
class SignUpPasswordViewModel extends _$SignUpPasswordViewModel {
  final _eventController = StreamController<SignUpPasswordEvent>();
  Stream<SignUpPasswordEvent> get eventStream => _eventController.stream;

  @override
  Future<SignUpPasswordState> build(String email) async {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    ref.onDispose(() {
      _eventController.close();
      passwordController.dispose();
      confirmPasswordController.dispose();
    });

    return SignUpPasswordState(
      email: email,
      passwordController: passwordController,
      confirmPasswordController: confirmPasswordController,
    );
  }
}