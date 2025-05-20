import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/state/deleted_workbook_state.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/component/delete_view/deleted_list_item.dart';
import 'package:mongo_ai/dashboard/presentation/component/delete_workbook_alert_dialog.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/base_selectable_view.dart';
import 'package:mongo_ai/dashboard/presentation/deleted_files/controller/deleted_files_view_model.dart';

class DeletedListView<T extends DeletedFilesViewModel>
    extends ConsumerStatefulWidget {
  final List<Workbook> workbookList;
  final T viewModel;

  const DeletedListView({
    super.key,
    required this.workbookList,
    required this.viewModel,
  });

  @override
  ConsumerState<DeletedListView<T>> createState() =>
      _DeletedListViewState<T>();
}

class _DeletedListViewState<T extends DeletedFilesViewModel>
    extends ConsumerState<DeletedListView<T>> {

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
      onSelection: (selected) {
        for (var workbook in selected) {
          widget.viewModel.selectWorkbook(workbook);
        }
      },
    );
  }

  Widget _buildItem(Workbook workbook) {
    return DeletedListItem(
      workbook: workbook,
      onSelect: () {
        widget.viewModel.selectWorkbook(workbook);
      },
      onPermanentDelete: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DeleteWorkbookAlertDialog(
              onDeleteWorkbook: () {
                widget.viewModel.permanentDeleteWorkbook(workbook);
              },
              title: '문제집 삭제하기',
            );
          },
        );
      },
      onRestore: () {
        widget.viewModel.restoreWorkbook(workbook);
      },
    );
  }
}
