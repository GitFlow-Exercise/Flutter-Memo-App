import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/presentation/create/controller/upload_raw_action.dart';
import 'package:mongo_ai/create/presentation/create/controller/upload_raw_state.dart';
import 'package:mongo_ai/create/presentation/create/widgets/upload_raw_text_field.dart';
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
        SingleChildScrollView(
          child: Column(
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
                                  e,
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
                Text(
                  '텍스트 입력',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColor.mediumGray,
                  ),
                ),
                const SizedBox(height: 10),
                UploadRawTextField(
                  onChanged: (_) {
                    setState(() {});
                  },
                  controller: widget.state.textController,
                ),
              ] else if (widget.state.selectedUploadType ==
                  AiConstant.inputImage) ...[
                const Text('이미지 업로드:'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed:
                      () => widget.onAction(const UploadRawAction.pickImage()),
                  child: const Text('이미지 선택'),
                ),
                widget.state.pickFile.when(
                  data: (file) {
                    if (file != null) {
                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          Text('선택된 이미지: ${file.fileName}'),
                          const SizedBox(height: 10),
                          Container(
                            height: 500,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Center(
                              child: Image.memory(
                                file.bytes,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  loading: () {
                    final file = widget.state.pickFile.value;
                    if (file != null) {
                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          Text('선택된 이미지: ${file.fileName}'),
                          const SizedBox(height: 10),
                          Container(
                            height: 500,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Image.memory(
                                    file.bytes,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Container(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  error: (error, stackTrace) => Text('에러: $error'),
                ),
              ] else if (widget.state.selectedUploadType ==
                  AiConstant.inputFile) ...[
                const Text('PDF 업로드:'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed:
                      () => widget.onAction(const UploadRawAction.pickPdf()),
                  child: const Text('PDF 선택'),
                ),
                widget.state.pickFile.when(
                  data: (file) {
                    if (file != null) {
                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          Text('선택된 PDF: ${file.fileName}'),
                          const SizedBox(height: 10),
                          Container(
                            height: 500,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: PdfPreview(
                              build: (format) => file.bytes,
                              maxPageWidth: 400,
                              allowPrinting: false,
                              allowSharing: false,
                              canChangePageFormat: false,
                              canChangeOrientation: false,
                              canDebug: false,
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  loading: () {
                    final file = widget.state.pickFile.value;
                    if (file != null) {
                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          Text('선택된 PDF: ${file.fileName}'),
                          const SizedBox(height: 10),
                          Container(
                            height: 500,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Stack(
                              children: [
                                PdfPreview(
                                  build: (format) => file.bytes,
                                  maxPageWidth: 400,
                                  allowPrinting: false,
                                  allowSharing: false,
                                  canChangePageFormat: false,
                                  canChangeOrientation: false,
                                  canDebug: false,
                                ),
                                Container(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  error: (error, stackTrace) => Text('에러: $error'),
                ),
              ],

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed:
                    widget.state.isSubmitEnabled
                        ? () =>
                            widget.onAction(const UploadRawAction.submitForm())
                        : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('제출하기'),
              ),
            ],
          ),
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
}
