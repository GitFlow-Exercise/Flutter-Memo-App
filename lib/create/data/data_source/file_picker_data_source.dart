import 'package:mongo_ai/create/data/dto/pick_file_dto.dart';

abstract interface class FilePickerDataSource {
  Future<PickFileDto?> selectImage();

  Future<PickFileDto?> selectPdf();
}
