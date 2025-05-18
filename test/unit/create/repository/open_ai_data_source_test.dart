import 'package:flutter_test/flutter_test.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/data/data_source/mock/mock_open_ai_data_source_impl.dart';
import 'package:mongo_ai/create/data/data_source/open_ai_data_source.dart';
import 'package:mongo_ai/create/data/repository/open_ai_repository_impl.dart';
import 'package:mongo_ai/create/domain/model/request/open_ai_body.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
import 'package:mongo_ai/create/domain/repository/open_ai_repository.dart';

void main() {
  late OpenAiDataSource openAiDataSource;
  late OpenAiRepository openAiRepository;

  setUpAll(() {
    openAiDataSource = MockOpenAiDataSourceImpl();
    openAiRepository = OpenAiRepositoryImpl(openAiDataSource: openAiDataSource);
  });

  test('open ai response test', () async {
    final body = OpenAiBody(input: [], instructions: 'instructions');
    final result = await openAiRepository.createProblem(body);

    switch (result) {
      case Success<OpenAiResponse, AppException>():
        expect(result.data, isA<OpenAiResponse>());

        expect(result.data.instructions, equals(body.instructions));
      case Error<OpenAiResponse, AppException>():
        expect(result, isA<Error<OpenAiResponse, AppException>>());
    }
  });
}
