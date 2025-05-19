import 'package:mongo_ai/create/data/data_source/prompt_data_source.dart';
import 'package:mongo_ai/create/data/dto/prompt_dto.dart';

class MockPromptDataSourceImpl implements PromptDataSource {
  MockPromptDataSourceImpl();

  @override
  Future<List<PromptDto>> getPrompts() async {
    return [
      PromptDto(id: 1, name: 'name1', detail: 'detail1'),
      PromptDto(id: 2, name: 'name2', detail: 'detail2'),
      PromptDto(id: 3, name: 'name3', detail: 'detail3'),
    ];
  }
}
