import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/data/data_source/folder_data_source.dart';
import 'package:mongo_ai/dashboard/data/dto/folder_dto.dart';
import 'package:mongo_ai/dashboard/data/mapper/folder_mapper.dart';
import 'package:mongo_ai/dashboard/domain/model/folder.dart';
import 'package:mongo_ai/dashboard/domain/repository/folder_repository.dart';

class FolderRepositoryImpl implements FolderRepository {
  final FolderDataSource _dataSource;

  const FolderRepositoryImpl({
    required FolderDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<Result<List<Folder>, AppException>> getFoldersByCurrentTeamId(int teamId) async {
    try {
      final folderDtos = await _dataSource.getFoldersByCurrentTeamId(teamId);
      final folders = folderDtos.map((e) => e.toFolder()).toList();
      return Result.success(folders);
    } catch(e, st) {
      return Result.error(
        AppException.remoteDataBase(
          message: '폴더 정보를 가져오는 중 오류가 발생했습니다.',
          error: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Result<Folder, AppException>> createFolder(FolderDto folderTemplate) async {
    try {
      final folderDto = await _dataSource.createFolder(folderTemplate);
      final folder = folderDto.toFolder();
      return Result.success(folder);
    } catch (e, st) {
      return Result.error(
        AppException.remoteDataBase(
          message: '폴더 생성 중 오류가 발생했습니다.',
          error: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Result<Folder, AppException>> updateFolder(Folder folder) async {
    try {
      final folderDto = folder.toFolderDto();
      await _dataSource.updateFolder(folderDto);
      return Result.success(folder);
    } catch (e, st) {
      return Result.error(
        AppException.remoteDataBase(
          message: '폴더 수정 중 오류가 발생했습니다.',
          error: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Result<Folder, AppException>> deleteFolder(Folder folder) async {
    try {
      await _dataSource.deleteFolder(folder.folderId);
      return Result.success(folder);
    } catch (e, st) {
      return Result.error(
        AppException.remoteDataBase(
          message: '폴더 삭제 중 오류가 발생했습니다.',
          error: e,
          stackTrace: st,
        ),
      );
    }
  }
}