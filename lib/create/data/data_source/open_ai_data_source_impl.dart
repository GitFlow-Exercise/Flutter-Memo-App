import 'package:mongo_ai/create/data/data_source/open_ai_data_source.dart';
import 'package:mongo_ai/create/data/dto/response/open_ai_response_dto.dart';
import 'package:mongo_ai/create/domain/model/request/open_ai_body.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OpenAiDataSourceImpl implements OpenAiDataSource {
  final SupabaseClient _client;

  OpenAiDataSourceImpl(this._client);

  @override
  Future<OpenAiResponseDto> createProblum(OpenAiBody body) async {
    final resp = await _client.functions.invoke(
      'functionName',
      body: body,
    );
    return OpenAiResponseDto.fromJson(resp.data);
  }
}
