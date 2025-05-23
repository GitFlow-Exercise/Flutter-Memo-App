import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/domain/model/problem.dart';

part 'create_complete_action.freezed.dart';

@freezed
sealed class CreateCompleteAction with _$CreateCompleteAction {
  const factory CreateCompleteAction.setFileName(String fileName) = SetFileName;

  const factory CreateCompleteAction.setTitle(String title) = SetTitle;

  const factory CreateCompleteAction.toggleEditMode() = ToggleEditMode;

  const factory CreateCompleteAction.previewPdf() = PreviewPdf;

  const factory CreateCompleteAction.updateProblem(
    int index,
    Problem updatedProblem,
  ) = UpdateProblem;

  const factory CreateCompleteAction.reorderOptions(
    int problemIndex,
    List<String> newOptions,
  ) = ReorderOptions;

  const factory CreateCompleteAction.saveProblems() = SaveProblems;
}
