import 'package:mongo_ai/core/constants/app_table_name.dart';
import 'package:mongo_ai/create/data/data_source/problem_data_source.dart';
import 'package:mongo_ai/create/data/dto/problem_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProblemDataSourceImpl implements ProblemDataSource {
  final SupabaseClient _client;

  const ProblemDataSourceImpl({required SupabaseClient client})
    : _client = client;

  @override
  Future<void> createProblems(List<ProblemDto> problems) async {
    // null인 필드는 Json에서 아예 삭제
    final data =
        problems
            .map((e) => e.toJson()..removeWhere((key, value) => value == null))
            .toList();

    await _client.from(AppTableName.problem).insert(data);
  }

  @override
  Future<List<ProblemDto>> getProblemsByWorkbookId(int workbookId) async {
    final response = await _client
        .from(AppTableName.problem)
        .select()
        .eq('workbook_id', workbookId);

    return response.map((e) => ProblemDto.fromJson(e)).toList();
  }
}
