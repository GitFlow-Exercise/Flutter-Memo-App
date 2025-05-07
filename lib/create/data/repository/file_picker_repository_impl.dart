import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/data/data_source/file_picker_data_source.dart';
import 'package:mongo_ai/create/data/mapper/pick_file_mapper.dart';
import 'package:mongo_ai/create/domain/model/pick_file.dart';
import 'package:mongo_ai/create/domain/repository/file_picker_repository.dart';

class FilePickerRepositoryImpl implements FilePickerRepository {
  final FilePickerDataSource _filePickerDataSource;

  const FilePickerRepositoryImpl({
    required FilePickerDataSource filePickerDataSource,
  }) : _filePickerDataSource = filePickerDataSource;

  @override
  Future<Result<PickFile, AppException>> selectImage() async {
    try {
      final pickFileDto = await _filePickerDataSource.selectImage();
      return Result.success(pickFileDto.toPickFile());
    } on AppException catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(
        AppException.filePick(
          message: 'Image를 불러오던 중 오류가 발생했습니다. Error: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<PickFile, AppException>> selectPdf() async {
    try {
      final pickFileDto = await _filePickerDataSource.selectPdf();
      return Result.success(pickFileDto.toPickFile());
    } on AppException catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(
        AppException.filePick(
          message: 'PDF를 불러오던 중 오류가 발생했습니다. Error: ${e.toString()}',
        ),
      );
    }
  }
}
