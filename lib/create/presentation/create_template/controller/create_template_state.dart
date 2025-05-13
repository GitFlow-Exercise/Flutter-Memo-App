import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/core/component/pdf_generator.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';

part 'create_template_state.freezed.dart';

@freezed
abstract class CreateTemplateState with _$CreateTemplateState {
  factory CreateTemplateState({
    @Default(AsyncValue.data(null)) AsyncValue<OpenAiResponse?> problem,
    @Default(true) bool isSingleColumns,
    @Default([]) List<Problem> problemList,
    @Default([]) List<Problem> orderedProblemList,
    required PdfGenerator pdfGenerator,
  }) = _CreateTemplateState;
}

// TODO(jh): UI 테스트용 모델. 추후 전달받은 값으로 모델 수정 예정
@freezed
abstract class Problem with _$Problem {
  factory Problem({required String title, required String content}) = _Problem;
}
