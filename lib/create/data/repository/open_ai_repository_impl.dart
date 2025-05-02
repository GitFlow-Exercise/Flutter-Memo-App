import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/data/data_source/open_ai_data_source.dart';
import 'package:mongo_ai/create/data/mapper/request/open_ai_body_mapper.dart';
import 'package:mongo_ai/create/data/mapper/response/open_ai_response_mapper.dart';
import 'package:mongo_ai/create/domain/model/request/open_ai_body.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
import 'package:mongo_ai/create/domain/repository/open_ai_repository.dart';

class OpenAiRepositoryImpl implements OpenAiRepository {
  final OpenAiDataSource _openAiDataSource;

  const OpenAiRepositoryImpl({required OpenAiDataSource openAiDataSource})
      : _openAiDataSource = openAiDataSource;

  @override
  Future<Result<OpenAiResponse, AppException>> createProblem(
      OpenAiBody body) async {
    try {
      final aiRespDto =
          await _openAiDataSource.createProblem(body.toOpenAiBodyDto());
      if (aiRespDto.status != AiConstant.completed) {
        AppException.network(
          message: '데이터를 가져오는 중 에러가 발생하였습니다.',
          error: 'aiRespDto.',
          stackTrace: StackTrace.current,
        );
      }
      return Result.success(aiRespDto.toContent());
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
