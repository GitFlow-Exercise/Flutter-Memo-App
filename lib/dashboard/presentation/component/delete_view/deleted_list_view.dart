import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/state/deleted_workbook_state.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/component/delete_view/deleted_list_item.dart';
import 'package:mongo_ai/dashboard/presentation/component/delete_workbook_alert_dialog.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/base_selectable_view.dart';
import 'package:mongo_ai/dashboard/presentation/deleted_files/controller/deleted_files_view_model.dart';

class DeletedListView extends ConsumerStatefulWidget {
  final List<Workbook> workbookList;
  final void Function(Workbook workbook) onSelectWorkbook;
  final void Function(Workbook workbook) onPermanentDeleteWorkbook;
  final void Function(Workbook workbook) onRestoreWorkbook;
  final void Function(List<Workbook> workbookList) onDrag;

  const DeletedListView({
    super.key,
    required this.workbookList,
    required this.onSelectWorkbook,
    required this.onPermanentDeleteWorkbook,
    required this.onRestoreWorkbook,
    required this.onDrag,
  });

  @override
  ConsumerState<DeletedListView> createState() => _DeletedListViewState();
}

class _DeletedListViewState extends ConsumerState<DeletedListView> {
  @override
  Widget build(BuildContext context) {
    final isDeleteMode = ref.watch(deletedWorkbookStateProvider).isDeleteMode;
    if(!isDeleteMode) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 90),
        itemCount: widget.workbookList.length,
        itemBuilder: (context, index) {
          return _buildItem(widget.workbookList[index]);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10);
        },
      );
    }

    return BaseSelectableView<Workbook>(
      items: widget.workbookList,
      itemBuilder: (context, workbook) {
        return _buildItem(workbook);
      },
      layoutBuilder: (context, children) => ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 90),
        itemCount: widget.workbookList.length,
        itemBuilder: (context, index) {
          return children[index];
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10);
        },
      ),
      onSelection: (List<Workbook> selectedList) {
        widget.onDrag(selectedList);
      },
    );
  }

  Widget _buildItem(Workbook workbook) {
    return DeletedListItem(
        workbook: workbook,
        onSelect: () => widget.onSelectWorkbook(workbook),
        onPermanentDelete: () => widget.onPermanentDeleteWorkbook(workbook),
        onRestore: () => widget.onRestoreWorkbook(workbook)
    );
  }
}
