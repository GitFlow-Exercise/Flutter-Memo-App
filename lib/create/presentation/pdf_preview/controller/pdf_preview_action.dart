import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';

part 'pdf_preview_action.freezed.dart';

@freezed
sealed class PdfPreViewActions with _$PdfPreViewActions {
  const factory PdfPreViewActions.setPdfData(OpenAiResponse response) =
      SetPdfData;

  const factory PdfPreViewActions.downloadPdf() = DownloadPdf;
}
