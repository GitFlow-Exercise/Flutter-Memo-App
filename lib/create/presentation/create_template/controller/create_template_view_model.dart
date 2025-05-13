import 'dart:async';
import 'package:mongo_ai/core/component/pdf_generator.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_event.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_template_view_model.g.dart';

@riverpod
class CreateTemplateViewModel extends _$CreateTemplateViewModel {
  final _eventController = StreamController<CreateTemplateEvent>();

  Stream<CreateTemplateEvent> get eventStream => _eventController.stream;

  @override
  CreateTemplateState build() {
    final pdfGenerator = PdfGenerator();

    ref.onDispose(() {
      _eventController.close();
    });

    return CreateTemplateState(
      // TODO(jh): UI 테스트용 데이터. 추후 삭제 예정
      problemList: [
        Problem(
          id: 1,
          title: '1. 다음 중 가장 적절한 것은?',
          content:
              'As technology advances, people are becoming increasingly dependent on smart devices to perform everyday tasks. While this convenience is undeniable, it also raises concerns about the gradual decline in certain cognitive skills. For instance, people often rely on navigation apps rather than using their own sense of direction. As a result, their ability to read maps or remember routes is diminishing. In the same way, the use of grammar-checking software can affect one’s attention to language structure. Although these tools are helpful, __________.',
        ),
        Problem(
          id: 2,
          title: '2. 다음 중 가장 적절한 것은?',
          content:
              'As technology advances, people are becoming increasingly dependent on smart devices to perform everyday tasks. While this convenience is undeniable, it also raises concerns about the gradual decline in certain cognitive skills. For instance, people often rely on navigation apps rather than using their own sense of direction. As a result, their ability to read maps or remember routes is diminishing. In the same way, the use of grammar-checking software can affect one’s attention to language structure. Although these tools are helpful, __________.',
        ),
        Problem(
          id: 3,
          title: '3. 다음 중 가장 적절한 것은?',
          content:
              'As technology advances, people are becoming increasingly dependent on smart devices to perform everyday tasks. While this convenience is undeniable, it also raises concerns about the gradual decline in certain cognitive skills. For instance, people often rely on navigation apps rather than using their own sense of direction. As a result, their ability to read maps or remember routes is diminishing. In the same way, the use of grammar-checking software can affect one’s attention to language structure. Although these tools are helpful, __________.',
        ),
        Problem(
          id: 4,
          title: '4. 다음 중 가장 적절한 것은?',
          content:
              'As technology advances, people are becoming increasingly dependent on smart devices to perform everyday tasks. While this convenience is undeniable, it also raises concerns about the gradual decline in certain cognitive skills. For instance, people often rely on navigation apps rather than using their own sense of direction. As a result, their ability to read maps or remember routes is diminishing. In the same way, the use of grammar-checking software can affect one’s attention to language structure. Although these tools are helpful, __________.',
        ),
        Problem(
          id: 5,
          title: '5. 다음 중 가장 적절한 것은?',
          content:
              'As technology advances, people are becoming increasingly dependent on smart devices to perform everyday tasks. While this convenience is undeniable, it also raises concerns about the gradual decline in certain cognitive skills. For instance, people often rely on navigation apps rather than using their own sense of direction. As a result, their ability to read maps or remember routes is diminishing. In the same way, the use of grammar-checking software can affect one’s attention to language structure. Although these tools are helpful, __________.',
        ),
        Problem(
          id: 6,
          title: '6. 다음 중 가장 적절한 것은?',
          content:
              'As technology advances, people are becoming increasingly dependent on smart devices to perform everyday tasks. While this convenience is undeniable, it also raises concerns about the gradual decline in certain cognitive skills. For instance, people often rely on navigation apps rather than using their own sense of direction. As a result, their ability to read maps or remember routes is diminishing. In the same way, the use of grammar-checking software can affect one’s attention to language structure. Although these tools are helpful, __________.',
        ),
      ],
      pdfGenerator: pdfGenerator,
    );
  }

  void toggleColumnsButton({required bool isSingleColumns}) {
    state = state.copyWith(isSingleColumns: isSingleColumns);
  }

  void setProblem({required OpenAiResponse problem}) {
    state = state.copyWith(problem: AsyncValue.data(problem));
  }

  void moveToOrderedList(Problem problem) {
    // 1. 원본 리스트(problemList)에서 항목 제거
    final problemList = List<Problem>.from(state.problemList);
    problemList.removeWhere((p) => p.id == problem.id);

    // 2. 대상 리스트(orderedProblemList)에 추가 (중복 방지)
    final orderedProblemList = List<Problem>.from(state.orderedProblemList);
    if (!orderedProblemList.any((p) => p.id == problem.id)) {
      orderedProblemList.add(
        Problem(id: problem.id, title: problem.title, content: problem.content),
      );
    }

    // 3. 상태 업데이트
    state = state.copyWith(
      problemList: problemList,
      orderedProblemList: orderedProblemList,
    );
  }

  void moveToOriginalList(Problem problem) {
    // 1. 대상 리스트(orderedProblemList)에서 항목 제거
    final orderedProblemList = List<Problem>.from(state.orderedProblemList);
    orderedProblemList.removeWhere((p) => p.id == problem.id);

    // 2. 원본 리스트(problemList)에 추가 (중복 방지)
    final problemList = List<Problem>.from(state.problemList);
    if (!problemList.any((p) => p.id == problem.id)) {
      problemList.add(
        Problem(id: problem.id, title: problem.title, content: problem.content),
      );
    }

    // 3. 상태 업데이트
    state = state.copyWith(
      problemList: problemList,
      orderedProblemList: orderedProblemList,
    );
  }

  void resetOrderedList() {
    // 1. 현재 orderedProblemList의 내용을 저장
    final itemsToRestore = List<Problem>.from(state.orderedProblemList);

    // 2. orderedProblemList 비우기
    final orderedProblemList = <Problem>[];

    // 3. problemList 복사
    final problemList = List<Problem>.from(state.problemList);

    // 4. orderedProblemList에 있던 항목들을 problemList에 추가 (중복 방지)
    for (final problem in itemsToRestore) {
      if (!problemList.any((p) => p.id == problem.id)) {
        problemList.add(
          Problem(
            id: problem.id,
            title: problem.title,
            content: problem.content,
          ),
        );
      }
    }

    // 5. problemList 정렬
    problemList.sort((a, b) => a.id.compareTo(b.id));

    // 6. 상태 업데이트
    state = state.copyWith(
      problemList: problemList,
      orderedProblemList: orderedProblemList,
    );
  }

  void generatePdf({required String contents}) async {
    //TODO(ok): 추후 템플릿 확정 시 변경 예정, 다음 화면으로 Uint8List 전달
    // => 임시로 화면 이동하는 로직 추가하였습니다.(명우)
    final bytes = await state.pdfGenerator.generatePdf(
      headerText: 'Text',
      contentsText: contents,
      useDoubleColumn: !state.isSingleColumns,
    );
    _eventController.add(CreateTemplateEvent.createPdfWithTemplate(bytes));
  }
}
