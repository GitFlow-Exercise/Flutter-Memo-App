import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/domain/model/prompt.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';

part 'create_problem_action.freezed.dart';

@freezed
sealed class CreateProblemAction with _$CreateProblemAction {
  const factory CreateProblemAction.changeType(Prompt type) = ChangeType;

  const factory CreateProblemAction.createProblem() = CreateProblem;

  const factory CreateProblemAction.setResponse(OpenAiResponse response) =
      SetResponse;

  const factory CreateProblemAction.getPrompts() = GetPrompts;
}
