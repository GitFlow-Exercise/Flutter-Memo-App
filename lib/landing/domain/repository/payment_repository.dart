import 'package:mongo_ai/landing/domain/model/payment_data.dart';

abstract interface class PaymentRepository {
  Future<void> payWithKakao(PaymentData data);
}
