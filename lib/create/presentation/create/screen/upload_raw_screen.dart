import 'package:flutter/material.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/presentation/create/controller/upload_raw_action.dart';
import 'package:mongo_ai/create/presentation/create/controller/upload_raw_state.dart';
import 'package:mongo_ai/create/presentation/create/widgets/upload_input_file.dart';
import 'package:mongo_ai/create/presentation/create/widgets/upload_input_image.dart';
import 'package:mongo_ai/create/presentation/create/widgets/upload_input_text.dart';

class UploadRawScreen extends StatelessWidget {
  final UploadRawState state;
  final void Function(UploadRawAction action) onAction;

  const UploadRawScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          '문제를 생성할 콘텐츠 소스를 선택하세요. 텍스트를 직접 입력하거나, 이미지나 PDF 파일을 업로드할 수 있습니다.',
          style: AppTextStyle.bodyRegular.copyWith(color: AppColor.lightGray),
        ),
        const SizedBox(height: 20),
        // 타입 설정하는 커스텀 탭바
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColor.lightGrayBorder)),
          ),
          child: Row(
            children:
                state.uploadTypes
                    .map(
                      (e) => InkWell(
                        onTap:
                            () => onAction(UploadRawAction.selectUploadType(e)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            border:
                                state.selectedUploadType == e
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

        // 텍스트/이미지/파일 별로
        // 위젯이 다르게 나오도록 구성 및 각 위젯 컴포넌트화
        if (state.selectedUploadType == AiConstant.inputText) ...[
          UploadInputText(
            controller: state.textController,
            clearTap: () => onAction(const UploadRawAction.clearText()),
          ),
        ] else if (state.selectedUploadType == AiConstant.inputImage) ...[
          UploadInputImage(
            file: state.pickFile,
            pickImage: () => onAction(const UploadRawAction.pickImage()),
            deleteFile: () => onAction(const UploadRawAction.deleteFile()),
            setDropController:
                (controller) =>
                    onAction(UploadRawAction.setDropController(controller)),
            onDropFile:
                (event) => onAction(
                  UploadRawAction.debounceAction(
                    () => onAction(UploadRawAction.dropImageFile(event)),
                  ),
                ),
          ),
        ] else if (state.selectedUploadType == AiConstant.inputFile) ...[
          UploadInputFile(
            file: state.pickFile,
            pickPdf: () => onAction(const UploadRawAction.pickPdf()),
            deleteFile: () => onAction(const UploadRawAction.deleteFile()),
            setDropController:
                (controller) =>
                    onAction(UploadRawAction.setDropController(controller)),
            onDropFile:
                (event) => onAction(
                  UploadRawAction.debounceAction(
                    () => onAction(UploadRawAction.dropPdfFile(event)),
                  ),
                ),
          ),
        ],
      ],
    );
  }

  // 현재 타입에 따라 탭바에 알맞게 텍스트 출력
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
