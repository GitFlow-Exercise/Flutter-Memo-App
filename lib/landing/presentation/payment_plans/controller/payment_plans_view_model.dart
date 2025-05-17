import 'dart:async';

import 'package:flutter/material.dart';
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
    _eventController.add(
      const PaymentPlansEvent.showSnackBar('시작하기 버튼이 클릭되었습니다'),
    );
    debugPrint('시작하기 버튼이 클릭되었습니다');
  }

  void showUpgradeButtonClicked() {
    _eventController.add(
      const PaymentPlansEvent.showSnackBar('지금 업그레이드 버튼이 클릭되었습니다'),
    );
    debugPrint('지금 업그레이드 버튼이 클릭되었습니다');
  }

  void showFreeTrial() {
    _eventController.add(
      const PaymentPlansEvent.showSnackBar('무료로 시작하기 버튼이 클릭되었습니다'),
    );
    debugPrint('무료로 시작하기 버튼이 클릭되었습니다');
  }
}
