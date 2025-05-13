import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/component/base_app_button.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
import 'package:mongo_ai/create/presentation/base/layout/ai_base_layout.dart';
import 'package:mongo_ai/create/presentation/base/widgets/ai_error_view.dart';
import 'package:mongo_ai/create/presentation/base/widgets/ai_loading_view.dart';
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
      case SuccessOCR(:final response):
        if (mounted) {
          // 클린 텍스트를 받아서
          // 해당 내용을 사용자에게 보여주는 확인 단계 Dialog
          // => 클린 텍스트가 자주 이상하게 나와서 사용자가 확인할 필요하다고 느낌
          showDialog(
            context: context,
            builder:
                (ctx) => AlertDialog(
                  backgroundColor: AppColor.white,
                  title: const Text(
                    '아래 텍스트가 추출된 내용입니다.\n확인 후 이상 없으면 ‘확인’하고 다음 단계로 이동해주세요.',
                  ),
                  content: SingleChildScrollView(
                    child: Text(response.getContent()),
                  ),
                  actions: [
                    BaseAppButton(onTap: () => context.pop(), text: '취소'),
                    BaseAppButton(
                      onTap: () {
                        ctx.pop();
                        context.push(Routes.createProblem, extra: response);
                      },
                      text: '확인',
                    ),
                  ],
                ),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(uploadRawViewModelProvider);
    final viewModel = ref.watch(uploadRawViewModelProvider.notifier);
    // 기본 레이아웃으로 UI가 묶이는 현상이 발생해서
    // Root 파일에서 로딩/에러/데이터 화면의 처리를 진행하도록 수정하였습니다.
    return state.when(
      data: (value) {
        return AiBaseLayout(
          title: '문제집 생성',
          subTitle: '콘텐츠 소스 선택',
          step: 1,
          maxWidth: 900,
          maxHeight: 850,
          nextTap: () {
            _handleAction(const UploadRawAction.submitForm(), viewModel);
          },
          isPopTap: false,
          child: UploadRawScreen(
            state: value,
            onAction: (action) => _handleAction(action, viewModel),
          ),
        );
      },
      error: (obj, stackTrace) => const AiErrorView(),
      loading: () => const AiLoadingView(),
    );
  }

  void _handleAction(UploadRawAction action, UploadRawViewModel viewModel) {
    switch (action) {
      case SelectUploadType(:final type):
        viewModel.handleSelectUploadType(type);
      case PickImage():
        viewModel.handlePickImage();
      case PickPdf():
        viewModel.handlePickPdf();
      case SubmitForm():
        viewModel.handleSubmitForm();
      case ClearText():
        viewModel.clearText();
    }
  }
}
