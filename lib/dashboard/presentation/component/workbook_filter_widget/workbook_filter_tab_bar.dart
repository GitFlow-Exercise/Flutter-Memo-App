import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/state/workbook_filter_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';

class WorkbookFilterTabBar extends ConsumerWidget {
  final void Function(bool showGridView) toggleGridView;

  const WorkbookFilterTabBar({super.key, required this.toggleGridView});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 상태에 따라 초기 탭 인덱스 결정 (0: Grid, 1: List)
    final showGridView = ref.watch(workbookFilterStateProvider).showGridView;
    return DefaultTabController(
      length: 2,
      initialIndex: showGridView ? 0 : 1,
      child: Container(
        width: 150,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: TabBar(
          onTap: (index) {
            toggleGridView(index == 0 ? true : false);
          },
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppColor.paleBlue,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Colors.transparent,
          dividerHeight: 0,
          labelColor: AppColor.primary,
          unselectedLabelColor: AppColor.paleGray,
          tabs: const [
            Tab(icon: Icon(Icons.grid_view)),
            Tab(icon: Icon(Icons.view_list)),
          ],
        ),
      ),
    );
  }
}
