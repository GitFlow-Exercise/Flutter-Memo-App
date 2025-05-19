import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/auth/presentation/check_otp/controller/check_otp_action.dart';
import 'package:mongo_ai/auth/presentation/check_otp/controller/check_otp_state.dart';
import 'package:mongo_ai/auth/presentation/components/auth_header_widget.dart';
import 'package:mongo_ai/core/extension/int_extension.dart';
import 'package:mongo_ai/core/extension/string_extension.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:pinput/pinput.dart';

class CheckOtpScreen extends ConsumerStatefulWidget {
  final AsyncValue<CheckOtpState> state;
  final void Function(CheckOtpAction action) onAction;

  const CheckOtpScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  ConsumerState<CheckOtpScreen> createState() => _CheckOtpScreenState();
}

class _CheckOtpScreenState extends ConsumerState<CheckOtpScreen> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 화면이 완전히 로드된 후 키보드 자동 표시
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.state.when(
      data: (state) {
        return Scaffold(
          backgroundColor: AppColor.lightBlue,
          body: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AuthHeaderWidget(),

                      const Gap(40),

                      // OTP 인증 카드
                      Container(
                        width: 448,
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.black.withValues(alpha: 0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: AppColor.black.withValues(alpha: 0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // 아이콘 원
                            Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor.paleBlue,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.mail_outline,
                                  color: AppColor.primary,
                                  size: 24,
                                ),
                              ),
                            ),
                            const Gap(16),

                            // 제목
                            Text(
                              '이메일 인증',
                              style: AppTextStyle.titleBold.copyWith(
                                color: AppColor.deepBlack,
                                fontSize: 24,
                              ),
                            ),
                            const Gap(8),

                            // 설명 텍스트
                            Text(
                              '${widget.state.value?.email.maskedEmail} 으로 전송된 인증 코드를 입력해주세요',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.bodyRegular.copyWith(
                                color: AppColor.mediumGray,
                                fontSize: 14,
                              ),
                            ),
                            const Gap(24),

                            // 핀 입력 필드
                            Pinput(
                              length: 6,
                              controller: state.codeController,
                              focusNode: _focusNode,
                              defaultPinTheme: PinTheme(
                                width: 48,
                                height: 48,
                                textStyle: AppTextStyle.bodyMedium.copyWith(
                                  fontSize: 16,
                                  color: AppColor.deepBlack,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.textfieldGrey,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColor.lightGrayBorder,
                                  ),
                                ),
                              ),
                              focusedPinTheme: PinTheme(
                                width: 48,
                                height: 48,
                                textStyle: AppTextStyle.bodyMedium.copyWith(
                                  fontSize: 16,
                                  color: AppColor.deepBlack,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.textfieldGrey,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColor.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                              submittedPinTheme: PinTheme(
                                width: 48,
                                height: 48,
                                textStyle: AppTextStyle.bodyMedium.copyWith(
                                  fontSize: 16,
                                  color: AppColor.deepBlack,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.textfieldGrey,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColor.lightGrayBorder,
                                  ),
                                ),
                              ),
                              errorPinTheme: PinTheme(
                                width: 48,
                                height: 48,
                                textStyle: AppTextStyle.bodyMedium.copyWith(
                                  fontSize: 16,
                                  color: AppColor.destructive,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.textfieldGrey,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColor.destructive,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),

                            if (state.errorMessage?.isNotEmpty ?? false)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  state.errorMessage!,
                                  style: AppTextStyle.captionRegular.copyWith(
                                    color: AppColor.destructive,
                                    fontSize: 12,
                                  ),
                                ),
                              ),

                            const Gap(16),

                            // 유효 시간
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.timer_outlined,
                                  size: 14,
                                  color: AppColor.mediumGray,
                                ),
                                const Gap(4),
                                Text(
                                  '유효시간: ${widget.state.value?.remainingSeconds.formatRemainingTime()}',
                                  style: AppTextStyle.captionRegular.copyWith(
                                    color: AppColor.mediumGray,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),

                            const Gap(24),

                            // 확인 버튼
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed:
                                    state.codeController.text.length == 6
                                        ? () => widget.onAction(
                                          const CheckOtpAction.onVerifyOtp(),
                                        )
                                        : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.primary,
                                  foregroundColor: AppColor.white,
                                  disabledBackgroundColor: AppColor.primary
                                      .withValues(alpha: 0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child:
                                    state.isOtpVerified.isLoading
                                        ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  AppColor.white,
                                                ),
                                          ),
                                        )
                                        : const Text('확인'),
                              ),
                            ),

                            const Gap(16),

                            // 재전송 텍스트
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '인증 코드를 받지 못하셨나요? ',
                                  style: AppTextStyle.captionRegular.copyWith(
                                    color: AppColor.mediumGray,
                                    fontSize: 12,
                                  ),
                                ),
                                GestureDetector(
                                  onTap:
                                      state.remainingSeconds != 0
                                          ? null
                                          : () => widget.onAction(
                                            const CheckOtpAction.onResendOtp(),
                                          ),
                                  child: Text(
                                    '재전송',
                                    style: AppTextStyle.captionRegular.copyWith(
                                      color:
                                          state.remainingSeconds == 0
                                              ? AppColor.primary
                                              : AppColor.lighterGray,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const Gap(24),

                      // 이전 단계로 돌아가기
                      GestureDetector(
                        onTap:
                            () => widget.onAction(
                              const CheckOtpAction.onBackTap(),
                            ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.arrow_back_ios,
                              size: 14,
                              color: AppColor.lightGray,
                            ),
                            const Gap(4),
                            Text(
                              '이전 단계로 돌아가기',
                              style: AppTextStyle.captionRegular.copyWith(
                                color: AppColor.lightGray,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 로딩 인디케이터 (전체 화면 가리기)
              if (state.isOtpVerified.isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  width: double.infinity,
                  height: double.infinity,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColor.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (error, stack) =>
              Scaffold(body: Center(child: Text('에러가 발생했습니다: $error'))),
    );
  }
}
