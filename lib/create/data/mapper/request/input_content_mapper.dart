import 'package:mongo_ai/create/data/dto/request/input_content_dto.dart';
import 'package:mongo_ai/create/domain/model/request/input_content.dart';

extension InputContentMapper on InputContent {
  InputContentDto toInputContentDto() {
    switch (this) {
      case InputText():
        final type = this as InputText;
        return InputTextDto(type: type.type, text: type.text);
      case InputImage():
        final type = this as InputImage;
        return InputImageDto(
          type: type.type,
          imageExtension: type.imageExtension,
          base64: type.base64,
        );
      case InputFile():
        final type = this as InputFile;
        return InputFileDto(
          type: type.type,
          filename: type.filename,
          base64: type.base64,
        );
    }
  }
}
