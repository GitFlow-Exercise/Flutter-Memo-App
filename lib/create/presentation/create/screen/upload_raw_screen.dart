import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/create/presentation/create/controller/upload_raw_action.dart';
import 'package:mongo_ai/create/presentation/create/controller/upload_raw_state.dart';
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
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '업로드 유형 선택',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed:
                            () => widget.onAction(
                              const UploadRawAction.selectUploadType(
                                AiConstant.inputText,
                              ),
                            ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              widget.state.selectedUploadType ==
                                      AiConstant.inputText
                                  ? Colors.blue
                                  : Colors.white70,
                        ),
                        child: const Text('텍스트'),
                      ),
                      ElevatedButton(
                        onPressed:
                            () => widget.onAction(
                              const UploadRawAction.selectUploadType(
                                AiConstant.inputImage,
                              ),
                            ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              widget.state.selectedUploadType ==
                                      AiConstant.inputImage
                                  ? Colors.blue
                                  : Colors.white70,
                        ),
                        child: const Text('이미지'),
                      ),
                      ElevatedButton(
                        onPressed:
                            () => widget.onAction(
                              const UploadRawAction.selectUploadType(
                                AiConstant.inputFile,
                              ),
                            ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              widget.state.selectedUploadType ==
                                      AiConstant.inputFile
                                  ? Colors.blue
                                  : Colors.white70,
                        ),
                        child: const Text('PDF'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  if (widget.state.selectedUploadType ==
                      AiConstant.inputText) ...[
                    const Text('텍스트 입력:'),
                    const SizedBox(height: 10),
                    TextField(
                      onChanged: (_) {
                        setState(() {});
                      },
                      controller: widget.state.textController,
                      maxLines: 12,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '텍스트를 입력하세요...',
                      ),
                    ),
                  ] else if (widget.state.selectedUploadType ==
                      AiConstant.inputImage) ...[
                    const Text('이미지 업로드:'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed:
                          () => widget.onAction(
                            const UploadRawAction.pickImage(),
                          ),
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
                                      color: Colors.black.withValues(
                                        alpha: 0.5,
                                      ),
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
                          () =>
                              widget.onAction(const UploadRawAction.pickPdf()),
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
                                      color: Colors.black.withValues(
                                        alpha: 0.5,
                                      ),
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

                  if (widget.state.selectedUploadType != null)
                    ElevatedButton(
                      onPressed:
                          widget.state.isSubmitEnabled
                              ? () => widget.onAction(
                                const UploadRawAction.submitForm(),
                              )
                              : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('제출하기'),
                    ),
                ],
              ),
            ),
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
