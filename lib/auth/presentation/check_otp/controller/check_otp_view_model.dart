import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mongo_ai/auth/domain/model/temp_user.dart';
import 'package:mongo_ai/auth/presentation/check_otp/controller/check_otp_event.dart';
import 'package:mongo_ai/auth/presentation/check_otp/controller/check_otp_state.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/extension/string_extension.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_otp_view_model.g.dart';

@riverpod
class CheckOtpViewModel extends _$CheckOtpViewModel {
  final _eventController = StreamController<CheckOtpEvent>();
  Timer? _countdownTimer;

  Stream<CheckOtpEvent> get eventStream => _eventController.stream;

  @override
  Future<CheckOtpState> build(String tempUserId) async {
    final codeController = TextEditingController();

    ref.onDispose(() {
      _eventController.close();
      codeController.dispose();
      _countdownTimer?.cancel();
    });

    // 임시 사용자 정보 가져오기
    final userResult = await _getTempUser(tempUserId);
    String maskedEmail = '';

    if (userResult case Success(data: final user)) {
      maskedEmail = user.email.maskedEmail;
      _startCountdownTimer();
    }

    return CheckOtpState(
      tempUserId: tempUserId,
      codeController: codeController,
      maskedEmail: maskedEmail,
    );
  }

  // OTP 검증 함수
  Future<bool> verifyOtp() async {
    state = state.whenData(
      (value) => value.copyWith(isVerifying: true, errorMessage: null),
    );

    final tempUser = await _getCurrentTempUser();
    if (tempUser == null) {
      _setError('인증 정보를 찾을 수 없습니다.');
      return false;
    }

    final code = state.value?.codeController.text.trim() ?? '';
    if (code.isEmpty) {
      _setError('인증번호를 입력해주세요.');
      return false;
    }

    // OTP 만료 확인
    if (tempUser.otpExpiration != null &&
        tempUser.otpExpiration!.isBefore(DateTime.now())) {
      _setError('인증번호가 만료되었습니다. 재전송을 눌러주세요.');
      return false;
    }

    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.verifyOtp(tempUser.email, code);

    switch (result) {
      case Success<void, AppException>():
        // OTP 검증 성공 시 tempUser에 검증된 OTP 저장
        await _updateTempUserWithOtp(code);
        _eventController.add(
          CheckOtpEvent.navigateToPasswordScreen(state.value!.tempUserId),
        );
        state = state.whenData((value) => value.copyWith(isVerifying: false));
        return true;
      case Error<void, AppException>():
        _setError(result.error.message);
        state = state.whenData((value) => value.copyWith(isVerifying: false));
        return false;
    }
  }

  // OTP 재전송 함수
  Future<void> resendOtp() async {
    final tempUser = await _getCurrentTempUser();
    if (tempUser == null) {
      _eventController.add(
        const CheckOtpEvent.showSnackBar('인증 정보를 찾을 수 없습니다.'),
      );
      return;
    }

    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.sendOtp(tempUser.email);

    switch (result) {
      case Success<void, AppException>():
        _resetTimer();
        _eventController.add(
          const CheckOtpEvent.showSnackBar('인증번호가 재전송되었습니다.'),
        );
        break;
      case Error<void, AppException>():
        _eventController.add(CheckOtpEvent.showSnackBar(result.error.message));
        break;
    }
  }

  // 타이머 시작
  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.value == null) return;

      final currentSeconds = state.value!.remainingSeconds - 1;
      if (currentSeconds <= 0) {
        timer.cancel();
        state = state.whenData((value) => value.copyWith(remainingSeconds: 0));
      } else {
        state = state.whenData(
          (value) => value.copyWith(remainingSeconds: currentSeconds),
        );
      }
    });
  }

  // 타이머 리셋
  void _resetTimer() {
    _countdownTimer?.cancel();
    state = state.whenData(
      (value) => value.copyWith(remainingSeconds: 300),
    ); // 5분으로 리셋
    _startCountdownTimer();
  }

  // 임시 사용자 정보 가져오기
  Future<Result<TempUser, AppException>> _getTempUser(String id) async {
    final repository = ref.read(tempStorageRepositoryProvider);
    return repository.retrieveData(id);
  }

  // 현재 임시 사용자 정보 가져오기
  Future<TempUser?> _getCurrentTempUser() async {
    final tempUserId = state.value?.tempUserId;
    if (tempUserId == null) return null;

    final result = await _getTempUser(tempUserId);
    return switch (result) {
      Success(data: final user) => user,
      Error() => null,
    };
  }

  // 임시 사용자 정보 업데이트
  Future<void> _updateTempUserWithOtp(String otp) async {
    final tempUser = await _getCurrentTempUser();
    if (tempUser == null) return;

    final repository = ref.read(tempStorageRepositoryProvider);
    final updatedUser = tempUser.copyWith(
      otp: otp,
      otpExpiration: DateTime.now().add(const Duration(minutes: 5)),
    );
    repository.storeData(updatedUser);
  }

  // 에러 메시지 설정
  void _setError(String message) {
    state = state.whenData(
      (value) => value.copyWith(errorMessage: message, isVerifying: false),
    );
    _eventController.add(CheckOtpEvent.showSnackBar(message));
  }

  // 남은 시간을 포맷팅
  String formatRemainingTime() {
    final seconds = state.value?.remainingSeconds ?? 0;
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
