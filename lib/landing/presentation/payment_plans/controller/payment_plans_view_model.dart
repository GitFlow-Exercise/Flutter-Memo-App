import 'package:flutter/material.dart';
import 'package:mongo_ai/core/extension/ref_extension.dart';
import 'package:mongo_ai/core/service/portone_payment_service.dart';
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

  void showUpgradeButtonClicked() {
    ref.showSnackBar('지금 업그레이드 버튼이 클릭되었습니다');
    debugPrint('지금 업그레이드 버튼이 클릭되었습니다');
    startPayment();
  }

  void showFreeTrial() {
    ref.showSnackBar('무료로 시작하기 버튼이 클릭되었습니다');

    debugPrint('무료로 시작하기 버튼이 클릭되었습니다');
  }
}
