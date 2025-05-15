import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_complete_action.freezed.dart';

@freezed
sealed class CreateCompleteAction with _$CreateCompleteAction {
  const factory CreateCompleteAction.setPdfData(Uint8List pdfBytes) =
      SetPdfData;

  const factory CreateCompleteAction.setFileName(String fileName) = SetFileName;

  const factory CreateCompleteAction.setTitle(String title) = SetTitle;

  const factory CreateCompleteAction.downloadPdf(Uint8List pdfBytes) =
      DownloadPdf;
}
