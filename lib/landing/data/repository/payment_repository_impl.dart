import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/landing/data/data_source/payment_data_source.dart';
import 'package:mongo_ai/landing/data/mapper/payment_request_mapper.dart';
import 'package:mongo_ai/landing/domain/model/payment_data.dart';
import 'package:mongo_ai/landing/domain/repository/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentDataSource _dataSource;

  PaymentRepositoryImpl({required PaymentDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<Result<void, AppException>> payWithKakao(PaymentData data) async {
    try {
      final keyData = await _dataSource.getPaymentKeys();
      final storeId = keyData.storeId;
      final channelKey = keyData.channelKey;

      data = data.copyWith(storeId: storeId, channelKey: channelKey);

      await _dataSource.payWithKakao(data.toDto());

      return const Result.success(null);
    } catch (e) {
      return Result.error(
        AppException.unknown(
          message: '알 수 없는 오류입니다',
          error: e.toString(),
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
}
