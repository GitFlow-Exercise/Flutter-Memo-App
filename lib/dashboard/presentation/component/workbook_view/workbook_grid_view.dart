import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/state/selected_workbook_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/base_selectable_view.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_grid_item.dart';
import 'package:mongo_ai/dashboard/presentation/controller/dashboard_navigation_view_model.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class WorkbookGridView<T extends DashboardNavigationViewModel> extends ConsumerStatefulWidget {
  final void Function(int workbookId) onClick;
  final List<Workbook> workbookList;
  final T viewModel;
  const WorkbookGridView({super.key, required this.onClick, required this.workbookList, required this.viewModel});

  @override
  ConsumerState<WorkbookGridView<T>> createState() => _WorkbookGridViewState<T>();
}

class _WorkbookGridViewState<T extends DashboardNavigationViewModel> extends ConsumerState<WorkbookGridView<T>> {

  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final isSelectMode = ref.watch(selectedWorkbookStateProvider).isSelectMode;
    final selectedWorkbooks = ref.watch(selectedWorkbookStateProvider).selectedWorkbooks;
    if (!isSelectMode) {
      return ResponsiveGridList(
        verticalGridMargin: 30,
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
        final isSelected = selectedWorkbooks.contains(workbook);

        Widget item = _buildItem(workbook);
        if (_isDragging && isSelected) {
          item = Opacity(opacity: 0.5, child: item);
        }

        return LongPressDraggable<List<Workbook>>(
          rootOverlay: true,      // 이것을 추가해야 루트 기준으로 오버레이가 가능해짐.
          dragAnchorStrategy: pointerDragAnchorStrategy,
          data: selectedWorkbooks,
          maxSimultaneousDrags: selectedWorkbooks.isNotEmpty ? 1 : 0,  //선택된 것이 없으면 드래그 비활성화
          feedback: Material(
            color: Colors.transparent,
            child: Icon(Icons.folder, size: 50, color: AppColor.lightGray),
          ),
          onDragStarted: () => setState(() => _isDragging = true),
          onDragEnd: (_) => setState(() => _isDragging = false),
          child: item,
        );
      },
      // 아이템을 포함할 그리드 설정
      layoutBuilder: (context, children) => ResponsiveGridList(
        verticalGridMargin: 30,
        horizontalGridMargin: 30,
        minItemWidth: 280,
        children: children,
      ),
      onSelection: (selected) {
        for (var workbook in selected) {
          widget.viewModel.selectWorkbook(workbook);
        }
      },
    );
  }

  Widget _buildItem(Workbook workbook) {
    return AspectRatio(
      aspectRatio: 1,
      child: WorkbookGridItem(
        workbook: workbook,
        onClick: () => widget.onClick(workbook.workbookId),
        onSelect: () => widget.viewModel.selectWorkbook(workbook),
        onBookmark: () => widget.viewModel.toggleBookmark(workbook),
        onMoveTrash: () => widget.viewModel.moveTrashWorkbook(workbook)
        ,
      ),
    );
  }
}
