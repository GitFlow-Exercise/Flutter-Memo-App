import 'dart:async';
import 'package:mongo_ai/core/component/pdf_generator.dart';
import 'package:mongo_ai/create/domain/model/create_template_params.dart';
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
  CreateTemplateState build(CreateTemplateParams params) {
    final pdfGenerator = PdfGenerator();

    ref.onDispose(() {
      _eventController.close();
    });

    final problems = parseCreateTemplateParamsToProblems(params);

    return CreateTemplateState(
      problemList: problems,
      pdfGenerator: pdfGenerator,
    );
  }

  void toggleColumnsButton({required bool isSingleColumns}) {
    state = state.copyWith(isSingleColumns: isSingleColumns);
  }

  void moveToOrderedList(Problem problem) {
    // 1. 원본 리스트(problemList)에서 항목 제거
    final problemList = List<Problem>.from(state.problemList);
    problemList.removeWhere((p) => p.number == problem.number);

    // 2. 대상 리스트(orderedProblemList)에 추가 (중복 방지)
    final orderedProblemList = List<Problem>.from(state.orderedProblemList);
    if (!orderedProblemList.any((p) => p.number == problem.number)) {
      orderedProblemList.add(
        Problem(
          number: problem.number,
          question: problem.question,
          passage: problem.passage,
          options: problem.options,
          problemType: problem.problemType,
          promptDetail: problem.promptDetail,
          cleanText: problem.cleanText,
        ),
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
    orderedProblemList.removeWhere((p) => p.number == problem.number);

    // 2. 원본 리스트(problemList)에 추가 (중복 방지)
    final problemList = List<Problem>.from(state.problemList);
    if (!problemList.any((p) => p.number == problem.number)) {
      problemList.add(
        Problem(
          number: problem.number,
          question: problem.question,
          passage: problem.passage,
          options: problem.options,
          problemType: problem.problemType,
          promptDetail: problem.promptDetail,
          cleanText: problem.cleanText,
        ),
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
      if (!problemList.any((p) => p.number == problem.number)) {
        problemList.add(
          Problem(
            number: problem.number,
            question: problem.question,
            passage: problem.passage,
            options: problem.options,
            problemType: problem.problemType,
            promptDetail: problem.promptDetail,
            cleanText: problem.cleanText,
          ),
        );
      }
    }

    // 5. problemList 정렬
    problemList.sort((a, b) => a.number.compareTo(b.number));

    // 6. 상태 업데이트
    state = state.copyWith(
      problemList: problemList,
      orderedProblemList: orderedProblemList,
    );
  }

  List<Problem> parseCreateTemplateParamsToProblems(
    CreateTemplateParams params,
  ) {
    final List<Problem> allProblems = [];
    int number = 1;

    for (int i = 0; i < params.response.length; i++) {
      final response = params.response[i];
      final promptDetail = params.prompt[i].detail;
      final cleanText = params.cleanText[i];

      final outputText = response.getContent();

      final problemBlocks =
          outputText
              .split('~^^~')
              .map((block) => block.trim())
              .where((block) => block.isNotEmpty)
              .toList();

      for (int j = 0; j < problemBlocks.length; j++) {
        final block = problemBlocks[j];
        final sections = block.split(RegExp(r'#\s*'));
        if (sections.length < 3) {
          throw const FormatException('올바른 형식의 문제 텍스트가 아닙니다.');
        }

        // 1. 지문 추출
        final passageSection = sections[1].trim();
        final passage = passageSection.split(':').skip(1).join(':').trim();

        // 2. 문제+보기 추출
        final questionSection = sections[2].trim();
        final lines =
            questionSection
                .split('\n')
                .map((line) => line.trim())
                .where((line) => line.isNotEmpty)
                .toList();

        // 3. 질문 추출
        final questionLine = lines.length > 1 ? lines[1] : '';

        // 4. 선택지 추출 (앞의 A./B./C./D. 제거)
        final options =
            lines
                .skip(2)
                .where((line) => line.startsWith(RegExp(r'[A-Da-d]\.')))
                .map((line) => line.replaceFirst(RegExp(r'^[A-Da-d]\.\s*'), ''))
                .toList();

        allProblems.add(
          Problem(
            number: number++,
            question: questionLine,
            passage: passage,
            options: options,
            problemType: params.prompt[i].name,
            promptDetail: promptDetail,
            cleanText: cleanText,
          ),
        );
      }
    }

    return allProblems;
  }
}
