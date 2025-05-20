import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/create/presentation/base/layout/ai_base_layout.dart';
import 'package:mongo_ai/create/presentation/base/widgets/ai_error_view.dart';
import 'package:mongo_ai/create/presentation/base/widgets/ai_loading_view.dart';
import 'package:mongo_ai/create/presentation/create/controller/upload_raw_action.dart';
import 'package:mongo_ai/create/presentation/create/controller/upload_raw_view_model.dart';
import 'upload_raw_screen.dart';

class UploadRawScreenRoot extends ConsumerWidget {
  const UploadRawScreenRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      case DeleteFile():
        viewModel.deleteFile();
      case SetDropController(:final controller):
        viewModel.setDropController(controller);
      case DropImageFile(:final event):
        viewModel.dropImageFile(event);
      case DropPdfFile(:final event):
        viewModel.dropPdfFile(event);
      case DebounceAction(:final action):
        viewModel.debounceAction(action);
    }
  }
}
