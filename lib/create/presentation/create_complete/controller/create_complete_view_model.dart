import 'dart:async';
import 'dart:typed_data';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/presentation/%08create_complete/controller/create_complete_event.dart';
import 'package:mongo_ai/create/presentation/%08create_complete/controller/create_complete_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_complete_view_model.g.dart';

@riverpod
class CreateCompleteViewModel extends _$CreateCompleteViewModel {
  final _eventController = StreamController<CreateCompleteEvent>();

  Stream<CreateCompleteEvent> get eventStream => _eventController.stream;

  @override
  CreateCompleteState build() {
    ref.onDispose(() {
      _eventController.close();
    });

    return CreateCompleteState(bytes: Uint8List(0));
  }

  // pdf data 설정
  void setPdfData(Uint8List pdfBytes) async {
    state = state.copyWith(bytes: pdfBytes);
  }

  void downloadPdf(Uint8List bytes) async {
    final useCase = ref.read(downloadPdfUseCase);
    final result = useCase.execute(pdfBytes: bytes, fileName: state.fileName);
    switch (result) {
      case Success<void, AppException>():
      case Error<void, AppException>():
        _eventController.add(
          const CreateCompleteEvent.showSnackBar('다운로드 중 에러가 발생하였습니다.'),
        );
    }
  }
}
