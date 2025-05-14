import 'package:mongo_ai/dashboard/data/data_source/folder_data_source.dart';
import 'package:mongo_ai/dashboard/data/dto/folder_dto.dart';
import 'package:mongo_ai/dashboard/domain/model/folder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FolderDataSourceImpl implements FolderDataSource {
  final SupabaseClient _client;

  const FolderDataSourceImpl({
    required SupabaseClient client,
  }) : _client = client;

  @override
  Future<List<FolderDto>> getFoldersByCurrentTeamId(int teamId) async {
    final data = await _client
        .from('folder')
        .select()
        .eq('team_id', teamId);

    return data
        .map((e) => FolderDto.fromJson(e))
        .toList();
  }

  @override
  Future<FolderDto> createFolder(FolderDto folderDto) async {
    // 폴더 생성 후 folderId와 createdAt을 포함한 폴더 정보를 반환
    final json = await _client
        .from('folder')
        .insert(folderDto.toJson())
        .single();

    return FolderDto.fromJson(json);
  }

  @override
  Future<void> updateFolder(FolderDto folderDto) async {
    // folderId는 Folder 모델에서 not null이므로 ! 사용
    await _client
        .from('folder')
        .update(folderDto.toJson())
        .eq('id', folderDto.folderId!.toInt())
        .single();
  }

  @override
  Future<void> deleteFolder(int folderId) async {
    await _client
        .from('folder')
        .delete()
        .eq('id', folderId);
  }
}