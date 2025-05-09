import 'package:mongo_ai/dashboard/data/data_source/folder_data_source.dart';
import 'package:mongo_ai/dashboard/data/dto/folder_dto.dart';
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
}