import 'dart:js' as js;
import 'dart:html';

import 'package:flutter/widgets.dart';

void startPayment() {
  final paymentData = {
    'storeId': 'STORE_ID', // 상점 ID
    'channelKey': 'CHANNEL_KEY', // 채널 키
    'amount': 100,
    'payMethod': 'EASY_PAY', // 결제 수단 (신용카드, 계좌이체 등)
    'orderId': 'order_1234',
    'orderName': '프로 플랜 결제',
    'customerName': '홍길동',
    'customerEmail': 'test@test.com',
    'customerPhone': '010-1234-5678',
    'pg': 'kakaopay', // PG사 코드
    'customerKey': 'unique_user_1234', // 고객 식별용 키 (회원 고유 ID)
    'currency': 'KRW', // 통화 코드 (KRW, USD 등),
    'popup': true, // 결제 완료 후 리다이렉트 URL
  };

  js.context.callMethod('startPortOnePayment', [
    js.JsObject.jsify(paymentData),
  ]);

  window.addEventListener('paymentResult', (event) {
    final detail = (event as CustomEvent).detail;
    if (detail['success']) {
      debugPrint('결제정보: $detail');
    } else {
      debugPrint('❌ 결제 실패: ${detail['error_msg']}');
    }
  });
}

/// 결제 결과를 수신하는 리스너 등록 (앱 시작 시 한 번만 호출)
void listenPaymentResult(
  void Function(bool success, Map<String, dynamic> data) callback,
) {
  window.addEventListener('paymentResult', (event) {
    final customEvent = event as CustomEvent;
    final detail = customEvent.detail as Map;

    final success = detail['success'] as bool;
    callback(success, Map<String, dynamic>.from(detail));
  });
}
