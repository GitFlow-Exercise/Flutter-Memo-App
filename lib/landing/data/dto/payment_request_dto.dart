import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_request_dto.g.dart';

@JsonSerializable()
class PaymentRequestDto {
  final String storeId;
  final String channelKey;
  final int totalAmount;
  final String payMethod;
  final String orderName;
  final String currency;

  const PaymentRequestDto({
    required this.storeId,
    required this.channelKey,
    required this.totalAmount,
    required this.payMethod,
    required this.orderName,
    required this.currency,
  });

  factory PaymentRequestDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentRequestDtoToJson(this);
}
