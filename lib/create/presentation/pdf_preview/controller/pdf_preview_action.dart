import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'pdf_preview_action.freezed.dart';

@freezed
sealed class PdfPreViewActions with _$PdfPreViewActions {
  const factory PdfPreViewActions.setPdfData(Uint8List pdfBytes) = SetPdfData;

  const factory PdfPreViewActions.downloadPdf(Uint8List pdfBytes) = DownloadPdf;
}
