import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/create/presentation/pdf_preview/controller/pdf_preview_action.dart';
import 'package:mongo_ai/create/presentation/pdf_preview/controller/pdf_preview_state.dart';
import 'package:printing/printing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class PdfPreviewScreen extends StatelessWidget {
  final PdfPreViewState state;
  final void Function(PdfPreViewActions action) onAction;
  const PdfPreviewScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return state.bytes.when(
      data: (value) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const Gap(10),
                    Text('선택된 PDF: ${state.fileName}'),
                    const Gap(10),
                    Container(
                      height: 800,
                      width: 400,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: PdfPreview(
                        build: (format) => value,
                        maxPageWidth: 400,
                        allowPrinting: false,
                        allowSharing: false,
                        canChangePageFormat: false,
                        canChangeOrientation: false,
                        canDebug: false,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(40),
              InkWell(
                onTap: () {
                  onAction(PdfPreViewActions.downloadPdf(value));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(border: Border.all()),
                  child: const Text('다운로드'),
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => const Center(child: Text('에러가 발생하였습니다.')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
