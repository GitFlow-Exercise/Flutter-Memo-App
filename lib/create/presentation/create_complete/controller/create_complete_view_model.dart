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

    return CreateCompleteState(
      bytes: Uint8List(0),
      problems: List.generate(
        8,
        (index) => CompleteProblem(
          id: index,
          question: '${index + 1}. 다음 중 가장 적절한 것은?',
          content:
              'As technology advances, people are becoming increasingly dependent on smart devices to perform everyday tasks. While this convenience is undeniable, it also raises concerns about the gradual decline in certain cognitive skills. For instance, people often rely on navigation apps rather than using their own sense of direction. As a result, their ability to read maps or remember routes is diminishing. In the same way, the use of grammar-checking software can affect one\'s attention to language structure. Although these tools are helpful, __________.',
          options: [
            '① They may lead users to overestimate their own writing abilities',
            '② They are designed to improve communication speed and accuracy ',
            '③ They encourage students to explore new ways of self-expression',
            '④ They provide a foundation for developing digital creativity',
            '⑤ They demonstrate how far AI technology has come',
          ],
        ),
      ),
      problemTypes: ['객관식, 주관식, 서술형'],
    );
  }

  void setFileName(String fileName) {
    state = state.copyWith(fileName: fileName);
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
