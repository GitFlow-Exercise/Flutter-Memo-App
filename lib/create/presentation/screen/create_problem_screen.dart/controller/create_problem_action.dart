import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/domain/model/request/open_ai_body.dart';

part 'create_problem_action.freezed.dart';

@freezed
sealed class CreateProblemAction with _$CreateProblemAction {
  const factory CreateProblemAction.changeType(String type) = ChangeType;

  const factory CreateProblemAction.createProblem(OpenAiBody body) =
      CreateProblem;

  const factory CreateProblemAction.setCleanText(String cleanText) =
      SetCleanText;
}
