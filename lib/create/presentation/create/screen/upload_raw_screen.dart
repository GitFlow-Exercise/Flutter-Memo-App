import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/presentation/create/controller/upload_raw_action.dart';
import 'package:mongo_ai/create/presentation/create/controller/upload_raw_state.dart';
import 'package:mongo_ai/create/presentation/create/widgets/upload_input_widgets.dart';
import 'package:printing/printing.dart';

class UploadRawScreen extends StatefulWidget {
  final UploadRawState state;
  final void Function(UploadRawAction action) onAction;

  const UploadRawScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  State<UploadRawScreen> createState() => _UploadRawScreenState();
}

class _UploadRawScreenState extends State<UploadRawScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              '문제를 생성할 콘텐츠 소스를 선택하세요. 텍스트를 직접 입력하거나, 이미지나 PDF 파일을 업로드할 수 있습니다.',
              style: AppTextStyle.bodyRegular.copyWith(
                color: AppColor.lightGray,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColor.lightGrayBorder),
                ),
              ),
              child: Row(
                children:
                    widget.state.uploadTypes
                        .map(
                          (e) => InkWell(
                            onTap:
                                () => widget.onAction(
                                  UploadRawAction.selectUploadType(e),
                                ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                border:
                                    widget.state.selectedUploadType == e
                                        ? const Border(
                                          bottom: BorderSide(
                                            color: AppColor.primary,
                                            width: 2,
                                          ),
                                        )
                                        : null,
                              ),
                              child: Text(
                                inputText(e),
                                style: AppTextStyle.bodyMedium.copyWith(
                                  color: AppColor.primary,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),

            const SizedBox(height: 30),

            if (widget.state.selectedUploadType == AiConstant.inputText) ...[
              UploadInputText(
                onChanged: (_) {
                  setState(() {});
                },
                controller: widget.state.textController,
              ),
            ] else if (widget.state.selectedUploadType ==
                AiConstant.inputImage) ...[
              UploadInputImage(
                file: widget.state.pickFile,
                onTap: () => widget.onAction(const UploadRawAction.pickImage()),
              ),
            ] else if (widget.state.selectedUploadType ==
                AiConstant.inputFile) ...[
              UploadInputFile(
                file: widget.state.pickFile,
                onTap: () => widget.onAction(const UploadRawAction.pickPdf()),
              ),
            ],
          ],
        ),
        if (widget.state.result.isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            width: double.infinity,
            height: double.infinity,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  String inputText(String text) {
    if (text == 'input_text') {
      return '텍스트 입력';
    } else if (text == 'input_image') {
      return '이미지 업로드';
    } else {
      return 'PDF 업로드';
    }
  }
}
