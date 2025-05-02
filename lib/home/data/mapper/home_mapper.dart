import 'package:mongo_ai/home/data/dto/home_dto.dart';
import 'package:mongo_ai/home/domain/model/home.dart';

extension HomeMapper on HomeDto {
  Home toHome() {
    return Home(title: title, description: description, imageUrl: imageUrl);
  }
}
