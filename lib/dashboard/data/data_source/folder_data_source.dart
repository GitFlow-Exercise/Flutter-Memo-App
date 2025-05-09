import 'package:mongo_ai/dashboard/data/dto/folder_dto.dart';

abstract interface class FolderDataSource {
  Future<List<FolderDto>> getFoldersByCurrentTeamId(int teamId);
}