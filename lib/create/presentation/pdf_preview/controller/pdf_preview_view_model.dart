import 'dart:async';
import 'dart:typed_data';
import 'package:mongo_ai/core/component/pdf_generator.dart';
import 'package:mongo_ai/create/domain/model/pick_file.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
import 'package:mongo_ai/create/presentation/pdf_preview/controller/pdf_preview_event.dart';
import 'package:mongo_ai/create/presentation/pdf_preview/controller/pdf_preview_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pdf_preview_view_model.g.dart';

@riverpod
class PdfPreViewViewModel extends _$PdfPreViewViewModel {
  final _eventController = StreamController<PdfPreViewEvent>();

  Stream<PdfPreViewEvent> get eventStream => _eventController.stream;

  @override
  PdfPreViewState build() {
    ref.onDispose(() {
      _eventController.close();
    });

    return const PdfPreViewState();
  }

  // pdf data 설정
  void setPdfData(OpenAiResponse response) async {
    state = state.copyWith(file: const AsyncValue.loading());
    final text = response.output[0].content[0].text;
    final pdfFile = await PdfGenerator().generatePdf(
      headerText: 'test header',
      contentsText: text,
      useDoubleColumn: true,
    );
    state = state.copyWith(
      file: AsyncValue.data(
        PickFile(
          type: 'pdf',
          fileName: 'pdfFile',
          fileExtension: 'pdf',
          bytes: pdfFile,
        ),
      ),
    );
  }

  void downloadPdf(Uint8List file) {}
}
