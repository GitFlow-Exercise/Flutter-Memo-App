import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/landing/domain/model/payment_data.dart';

abstract interface class PaymentRepository {
  Future<Result<void, AppException>> payWithKakao(PaymentData data);
}
