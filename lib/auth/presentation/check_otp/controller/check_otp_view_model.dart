import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mongo_ai/auth/presentation/check_otp/controller/check_otp_event.dart';
import 'package:mongo_ai/auth/presentation/check_otp/controller/check_otp_state.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_otp_view_model.g.dart';

@riverpod
class CheckOtpViewModel extends _$CheckOtpViewModel {
  final _eventController = StreamController<CheckOtpEvent>();

  Stream<CheckOtpEvent> get eventStream => _eventController.stream;

  @override
  Future<CheckOtpState> build(String email) async {
    final codeController = TextEditingController();

    ref.onDispose(() {
      _eventController.close();
      codeController.dispose();
    });

    return CheckOtpState(email: email, codeController: codeController);
  }

  Future<bool> verifyOtp() async {
    final authRepository = ref.read(authRepositoryProvider);
    final email = state.value?.email ?? '';
    final code = state.value?.codeController.text ?? '';
    final result = await authRepository.verifyOtp(email, code);

    switch (result) {
      case Success<void, AppException>():
        return true;
      case Error<void, AppException>():
        _eventController.add(CheckOtpEvent.showSnackBar(result.error.message));
        return false;
    }
  }
}
