import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/domain/model/pick_file.dart';

abstract interface class FilePickerRepository {
  Future<Result<PickFile, AppException>> selectImage();

  Future<Result<PickFile, AppException>> selectPdf();
}
