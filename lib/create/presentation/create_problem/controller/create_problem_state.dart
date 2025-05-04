import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/core/constants/prompt.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';

part 'create_problem_state.freezed.dart';

@freezed
abstract class CreateProblemState with _$CreateProblemState {
  const factory CreateProblemState({
    // AI 통신전에는 null 값을 지닌 AsyncData로 시작
    @Default(AsyncValue.data(null)) AsyncValue<OpenAiResponse?> problem,
    @Default('') String cleanText,
    @Default(Prompt.values) List<Prompt> problemTypes,
    @Default(Prompt.prompt1) Prompt problemType,
  }) = _CreateProblemState;
}
