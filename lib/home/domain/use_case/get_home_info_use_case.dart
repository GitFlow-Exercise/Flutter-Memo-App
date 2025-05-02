import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/home/domain/model/home.dart';
import 'package:mongo_ai/home/domain/repository/home_repository.dart';

class GetHomeInfoUseCase {
  final HomeRepository _repository;

  const GetHomeInfoUseCase(this._repository);

  Future<Result<Home, AppException>> getHomeInfo() async {
    return await _repository.getHomeInfo();
  }
}
