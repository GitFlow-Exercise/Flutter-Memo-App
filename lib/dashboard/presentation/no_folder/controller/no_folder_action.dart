import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

part 'no_folder_action.freezed.dart';

@freezed
sealed class NoFolderAction with _$NoFolderAction {
  const factory NoFolderAction.onClick(int workbookId) = OnClick;
  const factory NoFolderAction.onSelectWorkbook(Workbook workbook) = OnSelectWorkbook;
  const factory NoFolderAction.onToggleBookmark(Workbook workbook) = OnToggleBookmark;
  const factory NoFolderAction.onMoveTrashWorkbook(Workbook workbook) = OnMoveTrashWorkbook;
  const factory NoFolderAction.onDrag(List<Workbook> workbookList) = OnDrag;
}
