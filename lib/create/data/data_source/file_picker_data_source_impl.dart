import 'package:file_picker/file_picker.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/core/enum/allowed_extension_type.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/create/data/dto/pick_file_dto.dart';

import 'file_picker_data_source.dart';

class FilePickerDataSourceImpl implements FilePickerDataSource {
  @override
  Future<PickFileDto> selectImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          AllowedExtensionType.png.name,
        ],
      );

      return PickFileDto(
        type: AiConstant.inputImage,
        fileName: result?.files.single.name,
        bytes: result?.files.single.bytes,
        extension: result?.files.single.extension,
      );
    } catch (e) {
      throw AppException.filePick(
        message: 'Image를 불러오던 중 오류가 발생했습니다. Error: ${e.toString()}',
      );
    }
  }

  @override
  Future<PickFileDto> selectPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [AllowedExtensionType.pdf.name],
      );

      return PickFileDto(
        type: AiConstant.inputFile,
        fileName: result?.files.single.name,
        extension: result?.files.single.extension,
        bytes: result?.files.single.bytes,
      );
    } catch (e) {
      throw AppException.filePick(
        message: 'PDF를 불러오던 중 오류가 발생했습니다. Error: ${e.toString()}',
      );
    }
  }
}
