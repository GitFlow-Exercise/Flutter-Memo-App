import 'package:memo_app/core/exception/app_exception.dart';
import 'package:memo_app/core/result/result.dart';
import 'package:memo_app/home/domain/model/home.dart';

abstract interface class HomeRepository {
  Future<Result<Home, AppException>> getHomeInfo();
}
