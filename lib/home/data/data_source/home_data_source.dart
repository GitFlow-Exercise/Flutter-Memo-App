import 'package:memo_app/home/data/dto/home_dto.dart';

abstract interface class HomeDataSource {
  Future<HomeDto> getHomeInfo();
}
