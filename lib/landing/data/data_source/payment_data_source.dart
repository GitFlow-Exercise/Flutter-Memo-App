import 'package:mongo_ai/landing/data/dto/payment_key_response_dto.dart';
import 'package:mongo_ai/landing/data/dto/payment_request_dto.dart';

abstract interface class PaymentDataSource {
  Future<PaymentKeyResponseDto> getPaymentKeys();

  Future<void> payWithKakao(PaymentRequestDto data);
}
