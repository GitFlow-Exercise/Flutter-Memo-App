import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
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

    return Scaffold(
      body: CreateProblemScreen(state: state, onAction: _handleAction),
    );
  }

  Future<void> _handleAction(CreateProblemAction action) async {
    final viewModel = ref.read(
      createProblemViewModelProvider(widget.response).notifier,
    );
    switch (action) {
      case ChangeType(type: final type):
        viewModel.changeProblemType(type);
      case CreateProblem(body: final body):
        viewModel.createProblem(body);
      case SetResponse(response: final response):
        viewModel.setResponse(response);
      case GetPrompts():
        viewModel.getPrompts();
    }
  }
}
