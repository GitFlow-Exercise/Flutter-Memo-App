import 'package:mongo_ai/dashboard/data/data_source/folder_data_source.dart';
import 'package:mongo_ai/dashboard/data/dto/folder_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FolderDataSourceImpl implements FolderDataSource {
  final SupabaseClient _client;

  const FolderDataSourceImpl({required SupabaseClient client})
    : _client = client;

  @override
  Future<List<FolderDto>> getFoldersByCurrentTeamId(int teamId) async {
    final data = await _client.from('folder').select().eq('team_id', teamId);

    return data.map((e) => FolderDto.fromJson(e)).toList();
  }

  @override
  Future<FolderDto> createFolder(FolderDto folderDto) async {
    // null인 필드는 Json에서 아예 삭제
    final data = folderDto.toJson()..removeWhere((key, value) => value == null);

    // 폴더 생성 후 folderId와 createdAt을 포함한 폴더 정보를 반환
    final json =
        await _client
            .from('folder')
            .insert(data)
            .select() // Select를 붙여야 반환이 가능
            .single();

    return FolderDto.fromJson(json);
  }

  @override
  Future<void> updateFolder(FolderDto folderDto) async {
    // folderId는 Folder 모델에서 not null이므로 ! 사용
    await _client
        .from('folder')
        .update(folderDto.toJson())
        .eq('folder_id', folderDto.folderId!.toInt());
  }

  @override
  Future<void> deleteFolder(int folderId) async {
    await _client.from('folder').delete().eq('folder_id', folderId);
  }
}
