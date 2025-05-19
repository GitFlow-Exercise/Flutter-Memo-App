import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';

part 'create_template_action.freezed.dart';

@freezed
sealed class CreateTemplateAction with _$CreateTemplateAction {
  const factory CreateTemplateAction.onTapColumnsTemplate({
    required bool isSingleColumns,
  }) = OnTapColumnsTemplate;

  const factory CreateTemplateAction.onAcceptProblem(Problem problem) =
      OnAcceptProblem;

  const factory CreateTemplateAction.onAcceptOrderedProblem(Problem problem) =
      OnAcceptOrderedProblem;

  const factory CreateTemplateAction.onTapReset() = OnTapReset;

  const factory CreateTemplateAction.onTapNext() = OnTapNext;

  const factory CreateTemplateAction.onTapReCreate(Problem problem) =
      OnTapReCreate;

  const factory CreateTemplateAction.onDoubleTapProblem(Problem problem) =
      OnDoubleTapProblem;
}
