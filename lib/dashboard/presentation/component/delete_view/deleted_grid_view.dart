import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/state/deleted_workbook_state.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/component/delete_workbook_alert_dialog.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/base_selectable_view.dart';
import 'package:mongo_ai/dashboard/presentation/component/delete_view/deleted_grid_item.dart';
import 'package:mongo_ai/dashboard/presentation/deleted_files/controller/deleted_files_view_model.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class DeletedGridView extends ConsumerStatefulWidget {
  final List<Workbook> workbookList;
  final void Function(Workbook workbook) onSelectWorkbook;
  final void Function(Workbook workbook) onPermanentDeleteWorkbook;
  final void Function(Workbook workbook) onRestoreWorkbook;
  final void Function(List<Workbook> workbookList) onDrag;

  const DeletedGridView({
    super.key,
    required this.workbookList,
    required this.onSelectWorkbook,
    required this.onPermanentDeleteWorkbook,
    required this.onRestoreWorkbook,
    required this.onDrag,
  });

  @override
  ConsumerState<DeletedGridView> createState() => _DeletedGridViewState();
}

class _DeletedGridViewState extends ConsumerState<DeletedGridView> {
  @override
  Widget build(BuildContext context) {
    final isDeleteMode = ref.watch(deletedWorkbookStateProvider).isDeleteMode;
    if(!isDeleteMode) {
      return ResponsiveGridList(
        verticalGridMargin: 100,
        horizontalGridMargin: 30,
        minItemWidth: 280, // 원하는 아이템 최소 너비
        children: widget.workbookList.map((workbook) {
          return _buildItem(workbook);
        }).toList(),
      );
    }

    return BaseSelectableView<Workbook>(
      items: widget.workbookList,
      itemBuilder: (context, workbook) {
        return _buildItem(workbook);
      },
      layoutBuilder: (context, children) {
        return ResponsiveGridList(
          verticalGridMargin: 100,
          horizontalGridMargin: 30,
          minItemWidth: 280, // 원하는 아이템 최소 너비
          children: children,
        );
      },
      onSelection: (List<Workbook> selectedList) {
        widget.onDrag(selectedList);
      },
    );
  }

  Widget _buildItem(Workbook workbook) {
    return AspectRatio(
      aspectRatio: 1, // 비율 유지
      child: DeletedGridItem(
        workbook: workbook,
        onSelect: () => widget.onSelectWorkbook(workbook),
        onPermanentDelete: () => widget.onPermanentDeleteWorkbook(workbook),
        onRestore: () => widget.onRestoreWorkbook(workbook)
      ),
    );
  }
}
