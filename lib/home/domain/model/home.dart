import 'package:freezed_annotation/freezed_annotation.dart';

part 'home.freezed.dart';

@freezed
abstract class Home with _$Home {
  const factory Home({
    required String title,
    required String description,
    required String imageUrl,
  }) = _Home;
}
