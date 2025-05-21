import 'package:flutter/material.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/extension/ref_extension.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/service/portone_payment_service.dart';
import 'package:mongo_ai/landing/domain/model/payment_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_plans_view_model.g.dart';

@riverpod
class PaymentPlansViewModel extends _$PaymentPlansViewModel {
  @override
  void build() {}

  // 추가 메서드 정의
  void showStartButtonClicked() {
    ref.showSnackBar('시작하기 버튼이 클릭되었습니다');
    debugPrint('시작하기 버튼이 클릭되었습니다');
  }

  void showUpgradeButtonClicked() async {
    final isAuthenticated = ref.read(authRepositoryProvider).isAuthenticated;

    if (!isAuthenticated) {
      ref.showSnackBar('로그인 후 결제 가능합니다');
      return;
    }
    // No need for a separate variable here as we're using the result directly in payResult
    final result = await ref
        .read(paymentRepositoryProvider)
        .payWithKakao(
          const PaymentData(
            // storeId, channelKey는 서버에서 가져와서 등록함
            storeId: '',
            channelKey: '',
            totalAmount: 30000,
            payMethod: 'EASY_PAY',
            orderName: '프로 플랜 결제',
            currency: 'KRW',
          ),
        );

    switch (result) {
      case Success<void, AppException>():
        listenPaymentResult((bool success, Map<String, dynamic> data) async {
          if (success) {
            await ref.read(paymentRepositoryProvider).setPremiumUser();
            ref.showSnackBar('프로 플랜으로 업그레이드 되었습니다');
          } else {
            ref.showSnackBar('결제를 취소하였습니다');
          }
        });
      case Error<void, AppException>():
        ref.showSnackBar('결제에 실패하였습니다');
    }
  }

  void showFreeTrial() {
    ref.showSnackBar('무료로 시작하기 버튼이 클릭되었습니다');

    debugPrint('무료로 시작하기 버튼이 클릭되었습니다');
  }
}
