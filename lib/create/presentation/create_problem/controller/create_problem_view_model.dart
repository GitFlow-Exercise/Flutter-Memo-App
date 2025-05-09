import 'dart:async';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/domain/model/prompt.dart';
import 'package:mongo_ai/create/domain/model/request/open_ai_body.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
import 'package:mongo_ai/create/presentation/create_problem/controller/create_problem_event.dart';
import 'package:mongo_ai/create/presentation/create_problem/controller/create_problem_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_problem_view_model.g.dart';

@riverpod
class CreateProblemViewModel extends _$CreateProblemViewModel {
  final _eventController = StreamController<CreateProblemEvent>.broadcast();

  Stream<CreateProblemEvent> get eventStream => _eventController.stream;

  @override
  Future<CreateProblemState> build(OpenAiResponse response) async {
    ref.onDispose(() {
      _eventController.close();
    });

    await getPrompts();

    return CreateProblemState(response: response);
  }

  // AI에 요청을 보내서 데이터 생성
  void createProblem(OpenAiBody body) async {
    state = const AsyncValue.loading();

    final useCase = ref.read(createProblemUseCaseProvider);
    final result = await useCase.execute(body);

    switch (result) {
      case Success(data: final problem):
        state = state.whenData((cb) => cb.copyWith(problem: problem));
        _eventController.add(CreateProblemEvent.successOpenAIRequest(problem));
      case Error(error: final error):
        state = AsyncValue.error(error, error.stackTrace ?? StackTrace.empty);
    }

    if (state is AsyncError) {
      final error = (state as AsyncError).error;
      _eventController.add(
        CreateProblemEvent.showSnackBar('정보를 불러오는데 실패했습니다: $error'),
      );
    }
  }

  // prompt 데이터 조회
  Future<void> getPrompts() async {
    state = const AsyncValue.loading();

    final result = await ref.watch(getPromptsUseCaseProvider.future);

    switch (result) {
      case Success(data: final prompts):
        state = state.whenData(
          (cb) => cb.copyWith(problemTypes: prompts, problemType: prompts[0]),
        );
      case Error(error: final error):
        state = AsyncValue.error(error, error.stackTrace ?? StackTrace.empty);
    }

    if (state is AsyncError) {
      final error = (state as AsyncError).error;
      _eventController.add(
        CreateProblemEvent.showSnackBar('정보를 불러오는데 실패했습니다: $error'),
      );
    }
  }

  // cleanText 데이터 할당
  void setResponse(OpenAiResponse response) {
    state = state.whenData((cb) => cb.copyWith(response: response));
  }

  // 문제 유형 설정
  void changeProblemType(Prompt problemType) {
    state = state.whenData((cb) => cb.copyWith(problemType: problemType));
  }
}
