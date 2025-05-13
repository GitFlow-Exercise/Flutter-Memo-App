import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/domain/model/prompt.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';

part 'create_problem_state.freezed.dart';

@freezed
abstract class CreateProblemState with _$CreateProblemState {
  const factory CreateProblemState({
    // AI 통신전에는 null 값을 지닌 AsyncData로 시작
    @Default(null) OpenAiResponse? problem,
    // 생성자에서 넘겨받는 ai response
    @Default(null) OpenAiResponse? response,
    @Default([]) List<Prompt> problemTypes,
    @Default(null) Prompt? problemType,
    // hover 관련 속성
    @Default(null) Prompt? hoveredProblemType,
  }) = _CreateProblemState;
}
