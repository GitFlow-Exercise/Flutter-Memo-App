import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

part 'my_files_action.freezed.dart';

@freezed
sealed class MyFilesAction with _$MyFilesAction {
  const factory MyFilesAction.onClick(int workbookId) = OnClick;
  const factory MyFilesAction.onSelectWorkbook(Workbook workbook) = OnSelectWorkbook;
  const factory MyFilesAction.onToggleBookmark(Workbook workbook) = OnToggleBookmark;
  const factory MyFilesAction.onMoveTrashWorkbook(Workbook workbook) = OnMoveTrashWorkbook;
  const factory MyFilesAction.onDrag(List<Workbook> workbookList) = OnDrag;
}
