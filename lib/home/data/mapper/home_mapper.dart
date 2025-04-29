import 'package:memo_app/home/data/dto/home_dto.dart';
import 'package:memo_app/home/domain/model/home.dart';

extension HomeMapper on HomeDto {
  Home toHome() {
    return Home(title: title, description: description, imageUrl: imageUrl);
  }
}
