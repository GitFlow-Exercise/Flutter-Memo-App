import 'package:mongo_ai/core/component/pdf_generator.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/extension/ref_extension.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/domain/model/create_template_params.dart';
import 'package:mongo_ai/create/domain/model/problem.dart';
import 'package:mongo_ai/create/domain/model/request/input_content.dart';
import 'package:mongo_ai/create/domain/model/request/message_input.dart';
import 'package:mongo_ai/create/domain/model/request/open_ai_body.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_template_view_model.g.dart';

@riverpod
class CreateTemplateViewModel extends _$CreateTemplateViewModel {
  @override
  CreateTemplateState build(CreateTemplateParams params) {
    final pdfGenerator = PdfGenerator();

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
          requestContent: problem.requestContent,
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
          requestContent: problem.requestContent,
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
            requestContent: problem.requestContent,
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

  Future<void> reCreateProblem(Problem problem) async {
    state = state.copyWith(
      reCreatingNumber: problem.number,
    ); // 문제 '재생성 중'으로 상태 변경
    final body = OpenAiBody(
      input: [
        MessageInput(content: [InputContent.text(text: problem.cleanText)]),
      ],
      instructions: problem.promptDetail,
    );

    final useCase = ref.read(createProblemUseCaseProvider);
    final result = await useCase.execute(body);

    switch (result) {
      case Success(data: final response):
        // 문제 생성 성공 시, 문제 리스트 업데이트

        final updatedProblem = getProblemByResponse(response, problem);
        state = state.copyWith(
          problemList:
              state.problemList
                  .map((p) => p.number == problem.number ? updatedProblem : p)
                  .toList(),
          reCreatingNumber: null,
        );

      case Error():
        ref.showSnackBar('문제 재생성 중 에러가 발생하였습니다.');
    }
  }

  List<Problem> parseCreateTemplateParamsToProblems(
    CreateTemplateParams params,
  ) {
    final List<Problem> allProblems = [];
    int number = 1;

    for (int i = 0; i < params.response.length; i++) {
      final response = params.response[i];
      final promptDetail = params.prompt[i].detail;
      final promptName = params.prompt[i].name;

      final outputText = response.getContent();

      final problemBlocks =
          outputText
              .split('~^^~')
              .map((block) => block.trim())
              .where((block) => block.isNotEmpty)
              .toList();

      if (problemBlocks.length != params.cleanText.length) {
        throw FormatException(
          '유형 $promptName의 문제 수(${problemBlocks.length})와 클린텍스트 수(${params.cleanText.length})가 일치하지 않습니다.',
        );
      }

      for (int j = 0; j < problemBlocks.length; j++) {
        final block = problemBlocks[j];
        final sections = block.split(RegExp(r'#\s*'));
        if (sections.length < 3) {
          throw const FormatException('올바른 형식의 문제 텍스트가 아닙니다.');
        }

        // 1. 지문
        final passageSection = sections[1].trim();
        final passage = passageSection.split(':').skip(1).join(':').trim();

        // 2. 문제 및 보기
        final questionSection = sections[2].trim();
        final lines =
            questionSection
                .split('\n')
                .map((line) => line.trim())
                .where((line) => line.isNotEmpty)
                .toList();

        // 3. 질문
        final questionLine = lines.length > 1 ? lines[1] : '';

        // 4. 선택지
        final options =
            lines
                .skip(2)
                .where((line) => line.startsWith(RegExp(r'[A-Da-d]\.')))
                .map((line) => line.replaceFirst(RegExp(r'^[A-Da-d]\.\s*'), ''))
                .toList();

        allProblems.add(
          Problem(
            number: number,
            question: questionLine,
            passage: passage,
            options: options,
            problemType: promptName,
            promptDetail: promptDetail,
            requestContent: block,
            cleanText: params.cleanText[j], // 클린텍스트 순서에 맞춰 대응
          ),
        );

        number++;
      }
    }

    return allProblems;
  }

  Problem getProblemByResponse(OpenAiResponse response, Problem problem) {
    final sections = response.getContent().split(RegExp(r'#\s*'));
    if (sections.length < 3) {
      throw const FormatException('올바른 형식의 문제 텍스트가 아닙니다.');
    }

    // 1. 지문
    final passageSection = sections[1].trim();
    final passage = passageSection.split(':').skip(1).join(':').trim();

    // 2. 문제 및 보기
    final questionSection = sections[2].trim();
    final lines =
        questionSection
            .split('\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .toList();

    // 3. 질문
    final questionLine = lines.length > 1 ? lines[1] : '';

    // 4. 선택지
    final options =
        lines
            .skip(2)
            .where((line) => line.startsWith(RegExp(r'[A-Da-d]\.')))
            .map((line) => line.replaceFirst(RegExp(r'^[A-Da-d]\.\s*'), ''))
            .toList();

    return Problem(
      number: problem.number,
      question: questionLine,
      passage: passage,
      options: options,
      problemType: problem.problemType,
      promptDetail: problem.promptDetail,
      requestContent: response.getContent(), // 클린텍스트 순서에 맞춰 대응
      cleanText: problem.cleanText,
    );
  }

  // orderedProblemList 내 요소 순서대로 number 수정
  List<Problem> fixProblemList() {
    final updatedList =
        state.orderedProblemList
            .asMap()
            .entries
            .map((entry) => entry.value.copyWith(number: entry.key + 1))
            .toList();

    state = state.copyWith(orderedProblemList: updatedList);

    return state.orderedProblemList;
  }

  void quickOrderProblemList(bool isTypeGroup) {
    final problems = List<Problem>.from(state.problemList);
    final orderedProblems = <Problem>[];

    if (isTypeGroup) {
      // ✅ 유형별: 기존 problemList 그대로 넣기
      orderedProblems.addAll(problems);
    } else {
      // ✅ 문항별 정렬: cleanText 기준으로 묶기
      final Map<String, List<Problem>> cleanTextGroups = {};

      for (final problem in problems) {
        // cleanText를 키로 사용하여 그룹화
        // cleanText가 같은 문제들을 같은 그룹으로 묶기
        cleanTextGroups.putIfAbsent(problem.cleanText, () => []);
        cleanTextGroups[problem.cleanText]!.add(problem);
      }

      for (final group in cleanTextGroups.values) {
        orderedProblems.addAll(group);
      }
    }

    state = state.copyWith(
      problemList: [],
      orderedProblemList: orderedProblems,
    );
  }
}
