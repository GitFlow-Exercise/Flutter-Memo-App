import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/core/component/pdf_generator.dart';
import 'package:mongo_ai/create/domain/model/problem.dart';

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