import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/home/domain/model/home.dart';

abstract interface class HomeRepository {
  Future<Result<Home, AppException>> getHomeInfo();
}
