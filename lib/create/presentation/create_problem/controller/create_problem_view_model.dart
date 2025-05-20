import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/event/app_event.dart';
import 'package:mongo_ai/core/event/app_event_provider.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/core/utils/app_dialog.dart';
import 'package:mongo_ai/create/domain/model/create_template_params.dart';
import 'package:mongo_ai/create/domain/model/prompt.dart';
import 'package:mongo_ai/create/domain/model/request/input_content.dart';
import 'package:mongo_ai/create/domain/model/request/message_input.dart';
import 'package:mongo_ai/create/domain/model/request/open_ai_body.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
import 'package:mongo_ai/create/presentation/create_problem/controller/create_problem_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_problem_view_model.g.dart';

@riverpod
class CreateProblemViewModel extends _$CreateProblemViewModel {
  @override
  Future<CreateProblemState> build(OpenAiResponse response) async {
    await getPrompts();

    return CreateProblemState(response: response);
  }

  // AI에 요청을 보내서 데이터 생성
  void createProblem() async {
    final pState = state.value;
    // 값이 제대로 할당되지 않은게 있다면
    // 에러처리
    if (pState == null || pState.response == null) {
      state = const AsyncValue.error('에러가 발생하였습니다.', StackTrace.empty);
      return;
    }
    if (pState.selectedProblemTypes.isEmpty) {
      _readyForSnackBar('문제 유형을 선택해주세요.');
      return;
    }
    CreateTemplateParams? params;
    state = const AsyncValue.loading();
    // 복수 유형일 시 반복해서 요청
    for (final prompt in pState.selectedProblemTypes) {
      final body = OpenAiBody(
        input: [
          MessageInput(
            content: [InputContent.text(text: pState.response!.getContent())],
          ),
        ],
        instructions: prompt.detail,
      );

      final useCase = ref.read(createProblemUseCaseProvider);
      final result = await useCase.execute(body);

      switch (result) {
        case Success(data: final problem):
          params = CreateTemplateParams(
            response:
                params == null ? [problem] : [...params.response, problem],
            cleanText: pState.response!.getContent().split(
              AiConstant.splitEmoji,
            ),
            prompt: pState.selectedProblemTypes,
          );
        case Error(error: final error):
          state = AsyncValue.error(error, error.stackTrace ?? StackTrace.empty);
      }

      if (state is AsyncError) {
        final error = (state as AsyncError).error;
        _readyForSnackBar('정보를 불러오는데 실패했습니다: $error');
      }
    }
    // 만약 보낼 parameter 값에 문제가 있다면 에러처리
    if (params == null) {
      final error = '문제 생성 중 에러가 발생하였습니다.';
      state = AsyncValue.error(error, StackTrace.empty);
      _readyForSnackBar(error);
      return;
    }
    ref
        .read(appEventProvider.notifier)
        .addEvent(
          AppEventState.navigate(
            routeName: Routes.createTemplate,
            navigateMethod: NavigationMethod.push,
            extra: params,
          ),
        );
  }

  // prompt 데이터 조회
  Future<void> getPrompts() async {
    state = const AsyncValue.loading();

    final result = await ref.watch(getPromptsUseCaseProvider.future);

    switch (result) {
      case Success(data: final prompts):
        state = state.whenData(
          (cb) => cb.copyWith(
            problemTypes: prompts,
            selectedProblemTypes: [prompts[0]],
          ),
        );
      case Error(error: final error):
        state = AsyncValue.error(error, error.stackTrace ?? StackTrace.empty);
    }

    if (state is AsyncError) {
      final error = (state as AsyncError).error;
      _readyForSnackBar('정보를 불러오는데 실패했습니다: $error');
    }
  }

  // cleanText 데이터 할당
  void setResponse(OpenAiResponse response) {
    state = state.whenData((cb) => cb.copyWith(response: response));
  }

  // 문제 유형 설정
  void changeProblemType(Prompt problemType) {
    state = state.whenData((cb) {
      if (cb.selectedProblemTypes.contains(problemType)) {
        final selectedProblemTypes =
            cb.selectedProblemTypes.where((e) => e != problemType).toList();
        return cb.copyWith(selectedProblemTypes: selectedProblemTypes);
      }
      return cb.copyWith(
        selectedProblemTypes: [...cb.selectedProblemTypes, problemType],
      );
    });
  }

  // 문제 유형 설정
  void longPressed(Prompt prompt) {
    ref
        .read(appEventProvider.notifier)
        .addEvent(
          AppEventState.showDialog(
            builder:
                (ctx) => AppDialog.promptPreview(
                  ctx,
                  title: '내용',
                  content: prompt.detail,
                  buttonTap: () => ctx.pop(),
                ),
          ),
        );
  }

  // 하단 스낵바 출력
  void _readyForSnackBar(String message) {
    ref
        .read(appEventProvider.notifier)
        .addEvent(AppEventState.showSnackBar(message: message));
  }
}
