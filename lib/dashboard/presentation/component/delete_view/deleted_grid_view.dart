import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/state/deleted_workbook_state.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/component/delete_workbook_alert_dialog.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/base_selectable_view.dart';
import 'package:mongo_ai/dashboard/presentation/component/delete_view/deleted_grid_item.dart';
import 'package:mongo_ai/dashboard/presentation/deleted_files/controller/deleted_files_view_model.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class DeletedGridView<T extends DeletedFilesViewModel>
    extends ConsumerStatefulWidget {
  final List<Workbook> workbookList;
  final T viewModel;

  const DeletedGridView({
    super.key,
    required this.workbookList,
    required this.viewModel,
  });

  @override
  ConsumerState<DeletedGridView<T>> createState() =>
      _DeletedGridViewState<T>();
}

class _DeletedGridViewState<T extends DeletedFilesViewModel>
    extends ConsumerState<DeletedGridView<T>> {

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
      onSelection: (selected) {
        for (var workbook in selected) {
          widget.viewModel.selectWorkbook(workbook);
        }
      },
    );
  }

  Widget _buildItem(Workbook workbook) {
    return AspectRatio(
      aspectRatio: 1, // 비율 유지
      child: DeletedGridItem(
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
      ),
    );
  }
}
