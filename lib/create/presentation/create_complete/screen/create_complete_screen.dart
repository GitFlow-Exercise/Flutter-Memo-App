import 'dart:convert';
import 'dart:ui_web'; // For platformViewRegistry
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/component/pdf_generator.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

import 'package:mongo_ai/create/presentation/%08create_complete/controller/create_complete_action.dart';
import 'package:mongo_ai/create/presentation/%08create_complete/controller/create_complete_state.dart';
import 'package:mongo_ai/create/presentation/%08create_complete/widget/problem_preview_widget.dart';
import 'package:printing/printing.dart';

class CreateCompleteScreen extends StatelessWidget {
  final CreateCompleteState state;
  final void Function(CreateCompleteAction action) onAction;
  const CreateCompleteScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

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
            Text(
              '영어 문제집.pdf',
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColor.lightGray,
              ),
            ),
            const Gap(24),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                color: AppColor.paleBlue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 16,
                    color: AppColor.primary,
                  ),
                  const Gap(4),
                  Text(
                    '생성완료',
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: AppColor.primary,
                    ),
                  ),
                ],
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
              const ProblemPreviewWidget(),
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
                          '객관식, 주관식, 서술형',
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
                          '15문항',
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
            onPressed: () {
              _downloadPdf(PdfGenerator(), '2025년 3월 모의고사.pdf');
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
Future<void> _previewAndDownloadPdf(
  BuildContext context,
  PdfGenerator pdfGenerator,
  String fileName,
) async {
  // 로딩 표시
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(child: CircularProgressIndicator());
    },
  );

  try {
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

    // PDF 생성
    final pdfBytes = await pdfGenerator.generatePdf(
      headerText: '2025년 3월 모의고사',
      contentsText: content,
      useDoubleColumn: true,
    );

    // 로딩 다이얼로그 닫기
    if (context.mounted) Navigator.of(context).pop();

    // PDF 미리보기 다이얼로그 (인쇄 미리보기 스타일)
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: const Color(0xFFF5F5F5),
            insetPadding: EdgeInsets.zero, // 화면을 꽉 채우기 위해
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Row(
                children: [
                  // 오른쪽 사이드바 (설정 패널)
                  Container(
                    width: 300,
                    height: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(-2, 0),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 타이틀 및 설정 UI는 기존과 동일
                        // ... (생략)
                        const Spacer(),

                        // 버튼 그룹
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // 취소 버튼
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColor.mediumGray,
                                side: const BorderSide(
                                  color: AppColor.lightGrayBorder,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text('취소'),
                            ),
                            const SizedBox(width: 8),
                            // 저장 버튼
                            ElevatedButton(
                              onPressed: () {
                                pdfGenerator.downloadPdf(
                                  pdfBytes,
                                  fileName: fileName,
                                );
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text('저장'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // 왼쪽 PDF 미리보기 영역 - printing 패키지 사용
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      color: const Color(0xFFF5F5F5),
                      child: Column(
                        children: [
                          // 페이지 정보
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('페이지 1/5', style: AppTextStyle.bodyMedium),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // PDF 미리보기 영역 - PdfPreview 위젯 사용
                          Expanded(
                            child: Center(
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 600,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                // printing 패키지의 PdfPreview 위젯
                                child: PdfPreview(
                                  maxPageWidth: 600,
                                  build: (_) => pdfBytes,
                                  // 툴바 커스터마이징
                                  pdfPreviewPageDecoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  previewPageMargin: EdgeInsets.zero,
                                  // PdfPreview 옵션들
                                  canChangePageFormat: false,
                                  canChangeOrientation: false,
                                  canDebug: false,
                                  allowPrinting: false,
                                  allowSharing: false,
                                  actions: const [],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  } catch (e) {
    // 로딩 다이얼로그가 열려있으면 닫기
    if (context.mounted) Navigator.of(context).pop();

    print('PDF 생성 중 오류 발생: $e');
    // 사용자에게 오류 알림 표시
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('PDF 생성 중 오류가 발생했습니다: $e')));
    }
  }
}
