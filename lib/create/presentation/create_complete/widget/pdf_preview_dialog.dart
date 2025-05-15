import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:printing/printing.dart';

class PdfPreviewDialog extends StatelessWidget {
  final Uint8List pdfBytes;
  const PdfPreviewDialog({super.key, required this.pdfBytes});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFF5F5F5),
      insetPadding: const EdgeInsets.symmetric(
        vertical: 100,
        horizontal: 200,
      ), // 화면을 꽉 채우기 위해
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: [
            // 왼쪽 PDF 미리보기 영역 - printing 패키지 사용
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                color: const Color(0xFFF5F5F5),
                child: Column(
                  children: [
                    // PDF 미리보기 영역 - PdfPreview 위젯 사용
                    Expanded(
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 600),
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
            // 오른쪽 사이드바 (설정 패널)
            Container(
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 취소 버튼
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColor.mediumGray,
                      side: const BorderSide(color: AppColor.lightGrayBorder),
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
                      // pdfGenerator.downloadPdf(
                      //   pdfBytes,
                      //   fileName: fileName,
                      // );
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
                    child: const Text('다운로드'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
