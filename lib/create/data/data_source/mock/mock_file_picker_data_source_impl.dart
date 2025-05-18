import 'package:flutter/services.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/create/data/data_source/file_picker_data_source.dart';
import 'package:mongo_ai/create/data/dto/pick_file_dto.dart';

class MockFilePickerDataSourceImpl implements FilePickerDataSource {
  static const pdfExtension = 'pdf';
  static const pngExtension = 'png';
  @override
  Future<PickFileDto?> selectImage() async {
    return PickFileDto(
      type: AiConstant.inputImage,
      fileName: 'fileName',
      bytes: Uint8List(1),
      fileExtension: pngExtension,
    );
  }

  @override
  Future<PickFileDto?> selectPdf() async {
    return PickFileDto(
      type: AiConstant.inputFile,
      fileName: 'fileName',
      bytes: Uint8List(1),
      fileExtension: pdfExtension,
    );
  }
}
