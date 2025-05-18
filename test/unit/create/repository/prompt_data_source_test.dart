import 'package:flutter_test/flutter_test.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/data/data_source/mock/mock_prompt_data_source_impl.dart';
import 'package:mongo_ai/create/data/data_source/prompt_data_source.dart';
import 'package:mongo_ai/create/data/repository/prompt_repository_impl.dart';
import 'package:mongo_ai/create/domain/model/prompt.dart';
import 'package:mongo_ai/create/domain/repository/prompt_repository.dart';

void main() {
  late PromptDataSource promptDataSource;
  late PromptRepository promptRepository;

  setUpAll(() {
    promptDataSource = MokcPromptDataSourceImpl();
    promptRepository = PromptRepositoryImpl(promptDataSource: promptDataSource);
  });

  test('prompt data read test', () async {
    final result = await promptRepository.getPrompts();

    switch (result) {
      case Success<List<Prompt>, AppException>():
        expect(result.data, isA<List<Prompt>>());
        expect(result.data.length, equals(3));
      case Error<List<Prompt>, AppException>():
        expect(result, isA<Error<List<Prompt>, AppException>>());
    }
  });
}
