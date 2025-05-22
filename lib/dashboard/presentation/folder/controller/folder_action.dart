import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

part 'folder_action.freezed.dart';

@freezed
sealed class FolderAction with _$FolderAction {
  const factory FolderAction.onClick(int workbookId) = OnClick;
  const factory FolderAction.onSelectWorkbook(Workbook workbook) = OnSelectWorkbook;
  const factory FolderAction.onToggleBookmark(Workbook workbook) = OnToggleBookmark;
  const factory FolderAction.onMoveTrashWorkbook(Workbook workbook) = OnMoveTrashWorkbook;
  const factory FolderAction.onDrag(List<Workbook> workbookList) = OnDrag;
}
