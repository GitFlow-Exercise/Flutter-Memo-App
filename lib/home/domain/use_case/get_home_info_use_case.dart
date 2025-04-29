import 'package:memo_app/core/exception/app_exception.dart';
import 'package:memo_app/core/result/result.dart';
import 'package:memo_app/home/domain/model/home.dart';
import 'package:memo_app/home/domain/repository/home_repository.dart';

class GetHomeInfoUseCase {
  final HomeRepository _repository;

  const GetHomeInfoUseCase(this._repository);

  Future<Result<Home, AppException>> getHomeInfo() async {
    return await _repository.getHomeInfo();
  }
}
