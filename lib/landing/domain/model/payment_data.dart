import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_data.freezed.dart';

@freezed
abstract class PaymentData with _$PaymentData {
  const factory PaymentData({
    required String storeId,
    required String channelKey,
    required int totalAmount,
    required String payMethod,
    required String orderName,
    required String currency,
  }) = _PaymentData;
}
