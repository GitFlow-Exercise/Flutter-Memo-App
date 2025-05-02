import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/create/data/data_source/open_ai_data_source.dart';
import 'package:mongo_ai/create/data/dto/request/open_ai_body_dto.dart';
import 'package:mongo_ai/create/data/dto/response/open_ai_response_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OpenAiDataSourceImpl implements OpenAiDataSource {
  final SupabaseClient _client;

  OpenAiDataSourceImpl(this._client);

  @override
  Future<OpenAiResponseDto> createProblem(OpenAIBodyDto body) async {
    final resp = await _client.functions.invoke(
      AiConstant.invokeFunction,
      body: body,
    );
    print('datasource: $resp');
    return OpenAiResponseDto.fromJson(resp.data);
  }
}
