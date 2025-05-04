// input_content.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';

part 'input_content.freezed.dart';

@freezed
sealed class InputContent with _$InputContent {
  factory InputContent.text({
    @Default(AiConstant.inputText) String type,
    required String text,
  }) = InputText;

  factory InputContent.image({
    @Default(AiConstant.inputImage) String type,
    required String imageExtension,
    required String base64,
  }) = InputImage;

  factory InputContent.file({
    @Default(AiConstant.inputFile) String type,
    required String filename,
    required String base64,
  }) = InputFile;
}
