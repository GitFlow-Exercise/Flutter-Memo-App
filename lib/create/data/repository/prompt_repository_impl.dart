// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/data/data_source/prompt_data_source.dart';
import 'package:mongo_ai/create/data/mapper/prompt_mapper.dart';
import 'package:mongo_ai/create/domain/model/prompt.dart';
import 'package:mongo_ai/create/domain/repository/prompt_repository.dart';

class PromptRepositoryImpl implements PromptRepository {
  final PromptDataSource _promptDataSource;

  PromptRepositoryImpl({required PromptDataSource promptDataSource})
    : _promptDataSource = promptDataSource;

  @override
  Future<Result<List<Prompt>, AppException>> getPrompts() async {
    try {
      final prompts =
          (await _promptDataSource.getPrompts())
              .map((e) => e.toPrompt())
              .toList();
      return Result.success(prompts);
    } catch (e) {
      return Result.error(
        AppException.network(
          message: '데이터를 가져오는 중 에러가 발생하였습니다.',
          error: e,
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
}
