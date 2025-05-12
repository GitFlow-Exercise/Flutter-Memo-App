import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mongo_ai/auth/domain/model/temp_user.dart';
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
  Future<CheckOtpState> build(String tempUserId) async {
    final codeController = TextEditingController();

    ref.onDispose(() {
      _eventController.close();
      codeController.dispose();
    });

    return CheckOtpState(tempUserId: tempUserId, codeController: codeController);
  }

  Future<bool> verifyOtp() async {
    final tempStorageRepository = ref.read(tempStorageRepositoryProvider);
    final tempStoreResult = tempStorageRepository.retrieveData(state.value?.tempUserId ?? '');

    TempUser tempUser;

    switch (tempStoreResult) {
      case Success<TempUser, AppException>():
        tempUser = tempStoreResult.data;
      case Error<TempUser, AppException>():
        _eventController.add(CheckOtpEvent.showSnackBar(tempStoreResult.error.message));
        return false;
    }

    final authRepository = ref.read(authRepositoryProvider);
    final code = state.value?.codeController.text ?? '';

    if (code.trim().isEmpty) {
      _eventController.add(
        const CheckOtpEvent.showSnackBar('인증 코드를 입력해 주세요.'),
      );
      return false;
    }

    final result = await authRepository.verifyOtp(tempUser.email, code);

    switch (result) {
      case Success<void, AppException>():
        // TODO: 회원가입 요청 필요
        return true;
      case Error<void, AppException>():
        _eventController.add(CheckOtpEvent.showSnackBar(result.error.message));
        return false;
    }
  }
}
