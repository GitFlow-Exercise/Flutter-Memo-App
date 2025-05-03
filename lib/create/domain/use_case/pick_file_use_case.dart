import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/domain/model/pick_file.dart';
import 'package:mongo_ai/create/domain/repository/file_picker_repository.dart';

class PickFileUseCase {
  final FilePickerRepository _filePickerRepository;

  const PickFileUseCase({required FilePickerRepository filePickerRepository})
    : _filePickerRepository = filePickerRepository;

  Future<Result<PickFile, AppException>> selectImage() async {
    return await _filePickerRepository.selectImage();
  }

  Future<Result<PickFile, AppException>> selectPdf() async {
    return await _filePickerRepository.selectPdf();
  }
}
