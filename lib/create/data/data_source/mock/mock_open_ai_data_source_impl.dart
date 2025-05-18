import 'package:mongo_ai/create/data/data_source/open_ai_data_source.dart';
import 'package:mongo_ai/create/data/dto/request/open_ai_body_dto.dart';
import 'package:mongo_ai/create/data/dto/response/open_ai_response_content_dto.dart';
import 'package:mongo_ai/create/data/dto/response/open_ai_response_dto.dart';
import 'package:mongo_ai/create/data/dto/response/open_ai_response_output_dto.dart';

class MockOpenAiDataSourceImpl implements OpenAiDataSource {
  MockOpenAiDataSourceImpl();

  @override
  Future<OpenAiResponseDto> createProblem(OpenAIBodyDto body) async {
    return OpenAiResponseDto(
      id: 'id',
      status: 'status',
      instructions: 'instructions',
      output: [
        OpenAIResponseOutputDto(
          id: 'id',
          type: 'type',
          status: 'status',
          content: [
            OpenAIResponseContentDto(
              type: 'type',
              annotations: [],
              text: 'text',
            ),
          ],
          role: 'role',
        ),
      ],
    );
  }
}
