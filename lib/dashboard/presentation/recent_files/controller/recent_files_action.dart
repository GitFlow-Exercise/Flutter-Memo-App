import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

part 'recent_files_action.freezed.dart';

@freezed
sealed class RecentFilesAction with _$RecentFilesAction {
  const factory RecentFilesAction.onClick(int workbookId) = OnClick;
  const factory RecentFilesAction.onSelectWorkbook(Workbook workbook) = OnSelectWorkbook;
  const factory RecentFilesAction.onToggleBookmark(Workbook workbook) = OnToggleBookmark;
  const factory RecentFilesAction.onMoveTrashWorkbook(Workbook workbook) = OnMoveTrashWorkbook;
  const factory RecentFilesAction.onDrag(List<Workbook> workbookList) = OnDrag;
}
