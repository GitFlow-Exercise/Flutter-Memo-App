import 'dart:typed_data';

import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/create/data/dto/pick_file_dto.dart';
import 'package:mongo_ai/create/domain/model/pick_file.dart';

extension PickFileDtoMapper on PickFileDto {
  PickFile toPickFile() {
    return PickFile(
      type: type ?? AiConstant.inputText,
      fileName: fileName ?? 'unknown',
      bytes: bytes ?? Uint8List(0),
    );
  }
}
