import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/data/dto/folder_dto.dart';
import 'package:mongo_ai/dashboard/domain/model/folder.dart';

abstract interface class FolderRepository {
  Future<Result<List<Folder>, AppException>> getFoldersByCurrentTeamId(int teamId);
  Future<Result<Folder, AppException>> createFolder(FolderDto folderDto);
  Future<Result<Folder, AppException>> updateFolder(Folder folder);
  Future<Result<Folder, AppException>> deleteFolder(Folder folder);
}