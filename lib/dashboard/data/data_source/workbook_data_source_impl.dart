import 'package:mongo_ai/dashboard/data/data_source/workbook_data_source.dart';
import 'package:mongo_ai/dashboard/data/dto/workbook_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WorkbookDataSourceImpl implements WorkbookDataSource {
  final SupabaseClient _client;

  const WorkbookDataSourceImpl({
    required SupabaseClient client,
  }) : _client = client;

  @override
  Future<List<WorkbookDto>> getWorkbooksByCurrentTeamId(int teamId) async {
    final data = await _client
        .from('workbook_with_keyword_view')
        .select()
        .eq('team_id', teamId);

    return data
        .map((e) => WorkbookDto.fromJson(e))
        .toList();
  }
}