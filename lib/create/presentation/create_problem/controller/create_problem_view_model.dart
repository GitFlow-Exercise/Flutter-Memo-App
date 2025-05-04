import 'dart:async';
import 'package:mongo_ai/core/constants/prompt.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
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
  CreateProblemState build() {
    ref.onDispose(() {
      _eventController.close();
    });

    return const CreateProblemState();
  }

  // AI에 요청을 보내서 데이터 생성
  Future<Result<OpenAiResponse, AppException>> createProblem(
    OpenAiBody body,
  ) async {
    state = state.copyWith(problem: const AsyncValue.loading());

    final useCase = ref.read(createProblemUseCaseProvider);
    final result = await useCase.execute(body);

    switch (result) {
      case Success(data: final problem):
        print(problem.toString());
        state = state.copyWith(problem: AsyncValue.data(problem));
      case Error(error: final error):
        state = state.copyWith(
          problem: AsyncValue.error(
            error,
            error.stackTrace ?? StackTrace.empty,
          ),
        );
    }

    if (state.problem is AsyncError) {
      final error = (state.problem as AsyncError).error;
      _eventController.add(
        CreateProblemEvent.showSnackBar('정보를 불러오는데 실패했습니다: $error'),
      );
    }
    return result;
  }

  // cleanText 데이터 할당
  void setCleanText(String cleanText) {
    state = state.copyWith(cleanText: cleanText);
  }

  // 문제 유형 설정
  void changeProblemType(Prompt problemType) {
    state = state.copyWith(problemType: problemType);
  }
}
