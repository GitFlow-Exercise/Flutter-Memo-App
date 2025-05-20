import 'package:flutter/material.dart';
import 'package:mongo_ai/landing/data/data_source/payment_data_source.dart';
import 'package:mongo_ai/landing/data/dto/payment_key_response_dto.dart';
import 'package:mongo_ai/landing/data/dto/payment_request_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:js' as js;
import 'dart:html';

class PaymentDataSourceImpl implements PaymentDataSource {
  final SupabaseClient _client;

  PaymentDataSourceImpl({required SupabaseClient client}) : _client = client;

  @override
  Future<PaymentKeyResponseDto> getPaymentKeys() async {
    final response = await _client.functions.invoke('get-portone-key');
    return PaymentKeyResponseDto.fromJson(response.data);
  }

  @override
  Future<void> payWithKakao(PaymentRequestDto data) async {
    js.context.callMethod('startPortOnePayment', [
      js.JsObject.jsify(data.toJson()),
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
}
