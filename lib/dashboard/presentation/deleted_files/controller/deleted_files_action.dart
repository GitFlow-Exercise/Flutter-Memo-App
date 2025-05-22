import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

part 'deleted_files_action.freezed.dart';

@freezed
sealed class DeletedFilesAction with _$DeletedFilesAction {
  const factory DeletedFilesAction.onSelectWorkbook(Workbook workbook) = OnSelectWorkbook;
  const factory DeletedFilesAction.onPermanentDeleteWorkbook(Workbook workbook) = OnPermanentDeleteWorkbook;
  const factory DeletedFilesAction.onRestoreWorkbook(Workbook workbook) = OnRestoreWorkbook;
  const factory DeletedFilesAction.onDrag(List<Workbook> workbookList) = OnDrag;
}
