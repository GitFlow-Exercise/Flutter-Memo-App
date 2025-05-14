import 'dart:async';

import 'package:flutter/material.dart';
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
  Timer? _countdownTimer;

  Stream<CheckOtpEvent> get eventStream => _eventController.stream;

  @override
  Future<CheckOtpState> build(String email) async {
    final codeController = TextEditingController();

    ref.onDispose(() {
      _eventController.close();
      codeController.dispose();
      _countdownTimer?.cancel();
    });

    _startCountdownTimer();

    return CheckOtpState(codeController: codeController, email: email);
  }

  // OTP 검증
  Future<bool> verifyOtp() async {
    if (state.value == null) {
      return false;
    }

    state = state.whenData(
      (value) => value.copyWith(
        isOtpVerified: const AsyncLoading(),
        errorMessage: null,
      ),
    );

    final code = state.value!.codeController.text.trim();
    if (code.isEmpty) {
      _setError('인증번호를 입력해주세요.');
      return false;
    }

    // OTP 만료 확인
    if (state.value!.remainingSeconds <= 0) {
      _setError('인증번호가 만료되었습니다. 재전송을 눌러주세요.');
      return false;
    }

    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.verifyOtp(state.value!.email, code);

    switch (result) {
      case Success<void, AppException>():
        state = state.whenData(
          (value) => value.copyWith(isOtpVerified: const AsyncData(true)),
        );
        _eventController.add(CheckOtpEvent.navigateToPasswordScreen(email),);
        return true;
      case Error<void, AppException>():
        _setError(result.error.message);
        state = state.whenData(
          (value) => value.copyWith(isOtpVerified: const AsyncData(false)),
        );
        return false;
    }
  }

  // OTP 재전송 함수
  Future<void> resendOtp() async {
    // 실제 재전송 로직 주석 처리
    // final authRepository = ref.read(authRepositoryProvider);
    // final result = await authRepository.sendOtp(state.value!.email);

    // 바로 성공 처리
    _resetTimer();
    _resetCodeField();
    _eventController.add(const CheckOtpEvent.showSnackBar('인증번호가 재전송되었습니다.'));
  }

  void _resetCodeField() {
    state.value?.codeController.text = '';
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

  // 에러 메시지 설정
  void _setError(String message) {
    state = state.whenData(
      (value) => value.copyWith(
        errorMessage: message,
        isOtpVerified: const AsyncData(false),
      ),
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
