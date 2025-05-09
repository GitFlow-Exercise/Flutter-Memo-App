import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_template_action.freezed.dart';

@freezed
sealed class CreateTemplateAction with _$CreateTemplateAction {
  const factory CreateTemplateAction.onTapColumnsTemplate({
    required bool isSingleColumns,
  }) = OnTapColumnsTemplate;

  const factory CreateTemplateAction.onChangeContents({
    required String contents,
  }) = OnChangeContents;

  const factory CreateTemplateAction.createProblemForPdf({
    required String contents,
  }) = CreateProblemForPdf;
}
