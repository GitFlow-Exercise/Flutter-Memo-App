import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_key_response_dto.g.dart';

@JsonSerializable()
class PaymentKeyResponseDto {
  final String storeId;
  final String channelKey;

  const PaymentKeyResponseDto({
    required this.storeId,
    required this.channelKey,
  });
  factory PaymentKeyResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentKeyResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentKeyResponseDtoToJson(this);
}
