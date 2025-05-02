import 'package:mongo_ai/home/data/dto/home_dto.dart';

abstract interface class HomeDataSource {
  Future<HomeDto> getHomeInfo();
}
