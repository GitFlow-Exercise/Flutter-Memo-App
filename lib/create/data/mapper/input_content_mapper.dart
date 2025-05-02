import 'package:mongo_ai/create/data/dto/request/input_content_dto.dart';
import 'package:mongo_ai/create/domain/model/request/input_content.dart';

extension InputContentMapper on InputContent {
  InputContentDto toInputContentDto() {
    switch (this) {
      case InputText():
        final type = this as InputText;
        return InputTextDto(text: type.text);
      case InputImage():
        final type = this as InputImage;
        return InputImageDto(
          imageExtension: type.imageExtension,
          imageUrl: type.imageUrl,
        );
      case InputFile():
        final type = this as InputFile;
        return InputFileDto(
          filename: type.filename,
          fileData: type.fileData,
        );
    }
  }
}
