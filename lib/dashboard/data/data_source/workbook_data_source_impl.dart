import 'package:mongo_ai/dashboard/data/data_source/workbook_data_source.dart';
import 'package:mongo_ai/dashboard/data/dto/workbook_view_dto.dart';
import 'package:mongo_ai/dashboard/data/dto/workbook_table_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WorkbookDataSourceImpl implements WorkbookDataSource {
  final SupabaseClient _client;

  const WorkbookDataSourceImpl({
    required SupabaseClient client,
  }) : _client = client;

  @override
  Future<List<WorkbookViewDto>> getWorkbooksByCurrentTeamId(int teamId) async {
    final data = await _client
        .from('workbook_with_keyword_view')
        .select()
        .eq('team_id', teamId);

    return data
        .map((e) => WorkbookViewDto.fromJson(e))
        .toList();
  }

  @override
  Future<WorkbookViewDto> createWorkbook(WorkbookTableDto workbookTableDto) async {
    // null인 필드는 Json에서 아예 삭제
    final data = workbookTableDto.toJson()
      ..removeWhere((key, value) => value == null);

    // Workbook 생성 후 workbookId와 createdAt을 포함한 폴더 정보를 반환
    final json = await _client
        .from('workbook')
        .insert(data)
        .select()     // Select를 붙여야 반환이 가능
        .single();

    return WorkbookViewDto.fromJson(json);
  }

  @override
  Future<void> updateWorkbook(WorkbookTableDto workbookTableDto) async {
    // workbookId는 Workbook 모델에서 not null이므로 ! 사용
    await _client
        .from('workbook')
        .update(workbookTableDto.toJson())
        .eq('workbook_id', workbookTableDto.workbookId!.toInt());
  }

  @override
  Future<void> deleteWorkbook(int workbookId) async {
    await _client
        .from('workbook')
        .delete()
        .eq('workbook_id', workbookId);
  }
}