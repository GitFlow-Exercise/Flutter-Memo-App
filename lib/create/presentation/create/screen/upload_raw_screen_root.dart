import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/create/presentation/create/controller/upload_raw_action.dart';
import 'package:mongo_ai/create/presentation/create/controller/upload_raw_event.dart';
import 'package:mongo_ai/create/presentation/create/controller/upload_raw_view_model.dart';

import 'upload_raw_screen.dart';

class UploadRawScreenRoot extends ConsumerStatefulWidget {
  const UploadRawScreenRoot({super.key});

  @override
  ConsumerState<UploadRawScreenRoot> createState() =>
      _UploadRawScreenRootState();
}

class _UploadRawScreenRootState extends ConsumerState<UploadRawScreenRoot> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.watch(uploadRawViewModelProvider.notifier);

      _subscription = viewModel.eventStream.listen(_handleEvent);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleEvent(UploadRawEvent event) {
    switch (event) {
      case ShowSnackBar(message: final message):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      case SuccessOCR(: final response):
        if (mounted) {
          context.go(Routes.createProblem, extra: response);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(uploadRawViewModelProvider);
    final viewModel = ref.watch(uploadRawViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('파일 업로드')),
      body: UploadRawScreen(
        state: state,
        onAction: (action) => _handleAction(action, context, viewModel),
      ),
    );
  }

  void _handleAction(
    UploadRawAction action,
    BuildContext context,
    UploadRawViewModel viewModel,
  ) {
    switch (action) {
      case SelectUploadType(:final type):
        viewModel.handleSelectUploadType(type);
      case PickImage():
        viewModel.handlePickImage(context);
      case PickPdf():
        viewModel.handlePickPdf(context);
      case SubmitForm():
        viewModel.handleSubmitForm(context);
    }
  }
}
