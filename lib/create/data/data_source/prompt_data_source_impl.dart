// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mongo_ai/core/constants/app_table_name.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mongo_ai/create/data/data_source/prompt_data_source.dart';
import 'package:mongo_ai/create/data/dto/prompt_dto.dart';

class PromptDataSourceImpl implements PromptDataSource {
  final SupabaseClient _client;

  PromptDataSourceImpl({required SupabaseClient client}) : _client = client;

  @override
  Future<List<PromptDto>> getPrompts() async {
    final resp = await _client.from(AppTableName.prompt).select();
    return resp.map((e) => PromptDto.fromJson(e)).toList();
  }
}
