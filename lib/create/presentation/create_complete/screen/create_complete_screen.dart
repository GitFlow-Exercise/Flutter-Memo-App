import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/component/pdf_generator.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

import 'package:mongo_ai/create/presentation/%08create_complete/controller/create_complete_action.dart';
import 'package:mongo_ai/create/presentation/%08create_complete/controller/create_complete_state.dart';
import 'package:mongo_ai/create/presentation/%08create_complete/widget/pdf_preview_dialog.dart';
import 'package:mongo_ai/create/presentation/%08create_complete/widget/problem_preview_widget.dart';

// CompleteProblem 리스트를 마크다운 형식의 텍스트로 변환하는 함수
String convertProblemsToPdfContent(List<CompleteProblem> problems) {
  final StringBuffer buffer = StringBuffer();

  for (var problem in problems) {
    // 문제 번호와 질문 추가
    buffer.writeln(problem.question);
    buffer.writeln();

    // 본문 내용 추가
    buffer.writeln(problem.content);
    buffer.writeln();

    // 선택지 추가
    for (var option in problem.options) {
      buffer.writeln(option);
    }

    // 문제 사이에 빈 줄 추가 (마지막 문제 제외)
    if (problem != problems.last) {
      buffer.writeln();
      buffer.writeln();
    }
  }

  return buffer.toString();
}

class CreateCompleteScreen extends StatefulWidget {
  final CreateCompleteState state;
  final void Function(CreateCompleteAction action) onAction;
  const CreateCompleteScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  State<CreateCompleteScreen> createState() => _CreateCompleteScreenState();
}

class _CreateCompleteScreenState extends State<CreateCompleteScreen> {
  late final TextEditingController fileNameController;
  late final TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    fileNameController = TextEditingController(
      text:
          widget.state.isEditMode
              ? widget.state.fileName.replaceAll('.pdf', '')
              : null,
    );
    titleController = TextEditingController(
      text: widget.state.isEditMode ? widget.state.title : null,
    );
  }

  @override
  void dispose() {
    fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(
              Icons.picture_as_pdf,
              size: 16,
              color: AppColor.lightGray,
            ),
            const Gap(2),
            widget.state.fileName.isEmpty || widget.state.isEditMode
                ? SizedBox(
                  width: 200,
                  child: TextField(
                    cursorColor: AppColor.deepBlack,
                    controller: fileNameController,
                    decoration: InputDecoration(
                      hintText: widget.state.isEditMode ? null : '파일명을 입력하세요',
                      hintStyle: AppTextStyle.bodyMedium.copyWith(
                        color: AppColor.lightGray,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor.lightGrayBorder),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor.deepBlack),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: AppColor.lightGray,
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        widget.onAction(
                          CreateCompleteAction.setFileName(
                            '${value.trim()}.pdf',
                          ),
                        );
                      }
                    },
                  ),
                )
                : Text(
                  widget.state.fileName,
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColor.lightGray,
                  ),
                ),
            const Gap(24),
            GestureDetector(
              onTap: () {
                widget.onAction(const CreateCompleteAction.toggleEditMode());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        widget.state.isEditMode
                            ? AppColor.primary
                            : AppColor.lightGrayBorder,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_square,
                      size: 16,
                      color:
                          widget.state.isEditMode
                              ? AppColor.primary
                              : AppColor.lightGray,
                    ),
                    const Gap(4),
                    Text(
                      '문제 수정',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color:
                            widget.state.isEditMode
                                ? AppColor.primary
                                : AppColor.lightGray,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Gap(16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.lightGrayBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: AppColor.paleBlue,
                child: Text(
                  '생성된 문제집 미리보기',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColor.mediumGray,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ProblemPreviewWidget(
                state: widget.state,
                titleController: titleController,
                onTitleSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    widget.onAction(
                      CreateCompleteAction.setTitle(value.trim()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        const Gap(30),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColor.paleBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info, size: 18, color: Color(0xff64B5F6)),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '문제집 정보',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColor.mediumGray,
                      ),
                    ),
                    const Gap(12),
                    Row(
                      children: [
                        Text(
                          '문제 유형:',
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.paleGray,
                          ),
                        ),
                        const Gap(12),
                        Text(
                          widget.state.problemTypes.join(', '),
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.paleGray,
                          ),
                        ),
                        const Gap(12),
                        Text(
                          '총 문제 수:',
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.paleGray,
                          ),
                        ),
                        const Gap(12),
                        Text(
                          '${widget.state.problems.length}문항',
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.paleGray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Gap(24),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              // _previewAndDownloadPdf(
              //   context,
              //   PdfGenerator(),
              //   '2025년 3월 모의고사.pdf',
              // );

              String content = convertProblemsToPdfContent(
                widget.state.problems,
              );
              // PDF 생성
              final pdfBytes = await PdfGenerator().generatePdf(
                headerText: '2025년 3월 모의고사',
                contentsText: content,
                useDoubleColumn: widget.state.isDoubleColumns,
              );
              showDialog(
                context: context,
                builder: (context) {
                  return PdfPreviewScreen(pdfBytes: pdfBytes);
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.file_download_outlined,
                  size: 16,
                  color: AppColor.white,
                ),
                const Gap(8),
                Text(
                  '다운로드',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColor.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// PDF 다운로드 메서드
Future<void> _downloadPdf(PdfGenerator pdfGenerator, String fileName) async {
  // 문제 텍스트 구성 (마크다운 형식으로 변환)
  final content = '''
1. 다음 중 가장 적절한 것은?

As technology advances, people are becoming increasingly dependent on smart devices to perform everyday tasks. While this convenience is undeniable, it also raises concerns about the gradual decline in certain cognitive skills. For instance, people often rely on navigation apps rather than using their own sense of direction. As a result, their ability to read maps or remember routes is diminishing. In the same way, the use of grammar-checking software can affect one's attention to language structure. Although these tools are helpful, __________.

① They may lead users to overestimate their own writing abilities
② They are designed to improve communication speed and accuracy  
③ They encourage students to explore new ways of self-expression
④ They provide a foundation for developing digital creativity
⑤ They demonstrate how far AI technology has come

1. 다음 중 가장 적절한 것은?

As technology advances, people are becoming increasingly dependent on smart devices to perform everyday tasks. While this convenience is undeniable, it also raises concerns about the gradual decline in certain cognitive skills. For instance, people often rely on navigation apps rather than using their own sense of direction. As a result, their ability to read maps or remember routes is diminishing. In the same way, the use of grammar-checking software can affect one's attention to language structure. Although these tools are helpful, __________.

① They may lead users to overestimate their own writing abilities
② They are designed to improve communication speed and accuracy  
③ They encourage students to explore new ways of self-expression
④ They provide a foundation for developing digital creativity
⑤ They demonstrate how far AI technology has come

1. 다음 중 가장 적절한 것은?

As technology advances, people are becoming increasingly dependent on smart devices to perform everyday tasks. While this convenience is undeniable, it also raises concerns about the gradual decline in certain cognitive skills. For instance, people often rely on navigation apps rather than using their own sense of direction. As a result, their ability to read maps or remember routes is diminishing. In the same way, the use of grammar-checking software can affect one's attention to language structure. Although these tools are helpful, __________.

① They may lead users to overestimate their own writing abilities
② They are designed to improve communication speed and accuracy  
③ They encourage students to explore new ways of self-expression
④ They provide a foundation for developing digital creativity
⑤ They demonstrate how far AI technology has come

1. 다음 중 가장 적절한 것은?

As technology advances, people are becoming increasingly dependent on smart devices to perform everyday tasks. While this convenience is undeniable, it also raises concerns about the gradual decline in certain cognitive skills. For instance, people often rely on navigation apps rather than using their own sense of direction. As a result, their ability to read maps or remember routes is diminishing. In the same way, the use of grammar-checking software can affect one's attention to language structure. Although these tools are helpful, __________.

① They may lead users to overestimate their own writing abilities
② They are designed to improve communication speed and accuracy  
③ They encourage students to explore new ways of self-expression
④ They provide a foundation for developing digital creativity
⑤ They demonstrate how far AI technology has come
''';

  try {
    // PDF 생성 (단일 컬럼 레이아웃 사용)
    final pdfBytes = await pdfGenerator.generatePdf(
      headerText: '2025년 3월 모의고사',
      contentsText: content,
      useDoubleColumn: true,
    );

    // PDF 다운로드
    pdfGenerator.downloadPdf(pdfBytes, fileName: fileName);
  } catch (e) {
    print('PDF 생성 중 오류 발생: $e');
    // 필요에 따라 사용자에게 오류 알림 표시
  }
}

// PDF 미리보기 후 다운로드 메서드 수정
// Future<void> _previewAndDownloadPdf(
//   BuildContext context,
//   PdfGenerator pdfGenerator,
//   String fileName,
// ) async {
//   // 로딩 표시
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return const Center(child: CircularProgressIndicator());
//     },
//   );

//   try {
//     // 문제 텍스트 구성 (마크다운 형식으로 변환)

//     // PDF 생성
//     final pdfBytes = await pdfGenerator.generatePdf(
//       headerText: '2025년 3월 모의고사',
//       contentsText: _content,
//       useDoubleColumn: true,
//     );

//     // 로딩 다이얼로그 닫기
//     if (context.mounted) Navigator.of(context).pop();

//     // PDF 미리보기 다이얼로그 (인쇄 미리보기 스타일)
//     if (context.mounted) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return PdfPreviewScreen(pdfBytes: pdfBytes);
//         },
//       );
//     }
//   } catch (e) {
//     // 로딩 다이얼로그가 열려있으면 닫기
//     if (context.mounted) Navigator.of(context).pop();

//     print('PDF 생성 중 오류 발생: $e');
//     // 사용자에게 오류 알림 표시
//     if (context.mounted) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('PDF 생성 중 오류가 발생했습니다: $e')));
//     }
//   }
// }
