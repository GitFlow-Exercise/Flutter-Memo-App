// input_content.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'input_content.freezed.dart';
part 'input_content.g.dart';

@freezed
abstract class InputContent with _$InputContent {
  const factory InputContent.text({
    @Default('input_text') String type,
    required String text,
  }) = InputText;

  const factory InputContent.image({
    @Default('input_image') String type,
    required String imageExtension,
    required String imageUrl,
  }) = InputImage;

  const factory InputContent.file({
    @Default('input_file') String type,
    required String filename,
    required String fileData,
  }) = InputFile;

  factory InputContent.fromJson(Map<String, dynamic> json) =>
      _$InputContentFromJson(json);
}
