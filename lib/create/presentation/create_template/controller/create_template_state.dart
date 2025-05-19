import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/core/component/pdf_generator.dart';

part 'create_template_state.freezed.dart';

@freezed
abstract class CreateTemplateState with _$CreateTemplateState {
  factory CreateTemplateState({
    @Default(true) bool isSingleColumns,
    @Default([]) List<Problem> problemList,
    @Default([]) List<Problem> orderedProblemList,
    required PdfGenerator pdfGenerator,
    int? reCreatingNumber,
  }) = _CreateTemplateState;
}

@freezed
abstract class Problem with _$Problem {
  factory Problem({
    required int number, // 문제 번호
    required String question, // 문제
    required String passage, // 본문
    required List<String> options, // 보기
    required String problemType, // 문제 유형
    required String promptDetail, // 프롬프트 상세
    required String requestContent, // 재요청 본문
    required String cleanText, // 클린 텍스트
  }) = _Problem;
}
