import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/service/portone_payment_service.dart';
import 'package:mongo_ai/landing/domain/model/payment_data.dart';
import 'package:mongo_ai/landing/presentation/payment_plans/controller/payment_plans_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_plans_view_model.g.dart';

@riverpod
class PaymentPlansViewModel extends _$PaymentPlansViewModel {
  final _eventController = StreamController<PaymentPlansEvent>();

  Stream<PaymentPlansEvent> get eventStream => _eventController.stream;

  @override
  void build() {
    ref.onDispose(() {
      _eventController.close();
    });
  }

  // 추가 메서드 정의
  void showStartButtonClicked() {
    _eventController.add(const PaymentPlansEvent.showToast('시작하기 버튼이 클릭되었습니다'));
    debugPrint('시작하기 버튼이 클릭되었습니다');
  }

  void showUpgradeButtonClicked() async {
    final userId = ref.read(authRepositoryProvider).userId;
    if (userId == null) {
      _eventController.add(
        const PaymentPlansEvent.showToast('로그인 후 결제할 수 있습니다'),
      );
      return;
    }
    await ref
        .read(paymentRepositoryProvider)
        .payWithKakao(
          const PaymentData(
            storeId: '',
            channelKey: '',
            totalAmount: 30000,
            payMethod: 'EASY_PAY',
            orderName: '프로 플랜 결제',
            currency: 'KRW',
          ),
        );

    listenPaymentResult((bool success, Map<String, dynamic> data) {
      if (success) {
        _eventController.add(
          const PaymentPlansEvent.showToast('프로 플랜으로 업그레이드 되었습니다'),
        );
        debugPrint('결제 성공: $data');
      } else {
        _eventController.add(const PaymentPlansEvent.showToast('결제에 실패하였습니다'));
        debugPrint('결제 실패: $data');
      }
    });
  }

  void showFreeTrial() {
    _eventController.add(
      const PaymentPlansEvent.showToast('무료로 시작하기 버튼이 클릭되었습니다'),
    );
    debugPrint('무료로 시작하기 버튼이 클릭되었습니다');
  }
}
