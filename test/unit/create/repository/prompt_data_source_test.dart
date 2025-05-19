import 'package:flutter_test/flutter_test.dart';
import '../../../core/di/test_di.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/domain/model/prompt.dart';
import 'package:mongo_ai/create/domain/repository/prompt_repository.dart';

void main() {
  late PromptRepository promptRepository;

  setUpAll(() {
    mockdDISetup();
    promptRepository = mockLocator();
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
