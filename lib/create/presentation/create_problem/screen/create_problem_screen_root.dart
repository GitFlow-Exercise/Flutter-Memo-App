import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
import 'package:mongo_ai/create/presentation/base/layout/ai_base_layout.dart';
import 'package:mongo_ai/create/presentation/base/widgets/ai_error_view.dart';
import 'package:mongo_ai/create/presentation/base/widgets/ai_loading_view.dart';
import 'package:mongo_ai/create/presentation/create_problem/controller/create_problem_action.dart';
import 'package:mongo_ai/create/presentation/create_problem/controller/create_problem_event.dart';
import 'package:mongo_ai/create/presentation/create_problem/controller/create_problem_view_model.dart';
import 'package:mongo_ai/create/presentation/create_problem/screen/create_problem_screen.dart';

class CreateProblemScreenRoot extends ConsumerStatefulWidget {
  final OpenAiResponse response;
  const CreateProblemScreenRoot(this.response, {super.key});

  @override
  ConsumerState<CreateProblemScreenRoot> createState() =>
      _CreateProblemScreenRootState();
}

class _CreateProblemScreenRootState
    extends ConsumerState<CreateProblemScreenRoot> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.watch(
        createProblemViewModelProvider(widget.response).notifier,
      );
      _handleAction(const CreateProblemAction.getPrompts());

      _subscription = viewModel.eventStream.listen(_handleEvent);

      _handleAction(CreateProblemAction.setResponse(widget.response));
    });
  }

  // 1회성 이벤트 처리 메서드
  void _handleEvent(CreateProblemEvent event) {
    switch (event) {
      case ShowSnackBar(message: final message):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      case SuccessOpenAIRequest(:final response):
        if (mounted) {
          context.go(Routes.createTemplate, extra: response);
        }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createProblemViewModelProvider(widget.response));
    // 기본 레이아웃으로 UI가 묶이는 현상이 발생해서
    // Root 파일에서 로딩/에러/데이터 화면의 처리를 진행하도록 수정하였습니다.
    return state.when(
      data: (value) {
        return AiBaseLayout(
          title: '문제집 생성',
          subTitle: '문제 유형 선택',
          step: 2,
          maxWidth: 750,
          maxHeight: 650,
          nextTap: () {
            _handleAction(const CreateProblemAction.createProblem());
          },
          isPopTap: true,
          child: CreateProblemScreen(state: value, onAction: _handleAction),
        );
      },
      error: (error, stackTrace) => const AiErrorView(),
      loading: () => const AiLoadingView(),
    );
  }

  Future<void> _handleAction(CreateProblemAction action) async {
    final viewModel = ref.read(
      createProblemViewModelProvider(widget.response).notifier,
    );
    switch (action) {
      case ChangeType(type: final type):
        viewModel.changeProblemType(type);
      case CreateProblem():
        viewModel.createProblem();
      case SetResponse(response: final response):
        viewModel.setResponse(response);
      case GetPrompts():
        viewModel.getPrompts();
    }
  }
}
