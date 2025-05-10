import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';

part 'create_problem_event.freezed.dart';

@freezed
sealed class CreateProblemEvent with _$CreateProblemEvent {
  const factory CreateProblemEvent.showSnackBar(String message) = ShowSnackBar;

  const factory CreateProblemEvent.successOpenAIRequest(
    OpenAiResponse response,
  ) = SuccessOpenAIRequest;
}
