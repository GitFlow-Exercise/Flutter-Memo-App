import 'package:mongo_ai/landing/data/dto/payment_request_dto.dart';
import 'package:mongo_ai/landing/domain/model/payment_data.dart';

extension PaymentRequestMapper on PaymentData {
  PaymentRequestDto toDto() {
    return PaymentRequestDto(
      storeId: storeId,
      channelKey: channelKey,
      totalAmount: totalAmount,
      payMethod: payMethod,
      orderName: orderName,
      currency: currency,
    );
  }
}
