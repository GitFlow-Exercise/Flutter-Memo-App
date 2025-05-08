import 'dart:typed_data';
import 'package:mongo_ai/core/component/pdf_generator.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';

class DownloadPdfUseCase {
  const DownloadPdfUseCase();

  Result<void, AppException> execute({
    required Uint8List pdfBytes,
    required String fileName,
  }) {
    try {
      return Result.success(PdfGenerator().downloadPdf(pdfBytes));
    } catch (e) {
      return const Result.error(
        AppException.pdfDownload(message: '다운로드 중 에러가 발생하였습니다.'),
      );
    }
  }
}
