import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/enum/workbook_sort_option.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/dashboard/presentation/component/button_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/folder_list_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/team_list_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_filter_bookmark_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_filter_sort_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_filter_tab_bar.dart';
import 'package:mongo_ai/dashboard/presentation/controller/dashboard_view_model.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardScreen({super.key, required this.navigationShell});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardViewModelProvider);
    final viewModel = ref.read(dashboardViewModelProvider.notifier);
    return state.when(
      data: (dashboard) {
        return Scaffold(
          backgroundColor: AppColor.white,
          body: Row(
            children: [
              Container(
                width: 250,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(20),
                      SizedBox(
                        height: 40,
                        child: Center(
                          child: Row(
                            children: [
                              Text(
                                'Mongo AI',
                                style: AppTextStyle.titleBold.copyWith(
                                  color: AppColor.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(10),
                      SizedBox(
                        height: 40,
                        child: TeamListWidget(
                          currentTeamId: dashboard.currentTeamId,
                          onClickTeam: (int teamId) {
                            viewModel.selectTeam(teamId);
                          },
                        ),
                      ),
                      const Gap(10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColor.lightGrayBorder,
                              width: 1,
                            ),
                            top: BorderSide(
                              color: AppColor.lightGrayBorder,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Gap(10),
                            _sideBarTile(0, '내 항목', Icons.person),
                            const Gap(10),
                            _sideBarTile(1, '최근 항목', Icons.timelapse),
                            const Gap(10),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('폴더', style: AppTextStyle.bodyMedium),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      FolderListWidget(
                        onClickFolder: (int folderId) {
                          viewModel.selectFolderId(folderId);
                          _onTap(context, 2);
                        },
                        onClickExpand: () {},
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Gap(20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Icon(Icons.person, color: AppColor.deepBlack),
                            const Gap(10),
                            Text(
                              dashboard.userProfile.userName,
                              style: AppTextStyle.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('님 환영합니다', style: AppTextStyle.bodyMedium),
                            const Spacer(),
                            ButtonWidget(
                              buttonText: '새로 만들기',
                              icon: const Icon(
                                Icons.auto_awesome,
                                color: AppColor.white,
                              ),
                              onClick: () {
                                context.push(Routes.create);
                              },
                            ),
                            const Gap(10),
                            ButtonWidget(
                              buttonText: '문서 병합하기',
                              icon: const Icon(
                                Icons.layers,
                                color: AppColor.white,
                              ),
                              onClick: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        height: 40,
                        child: Row(
                          children: [
                            const Spacer(),
                            WorkbookFilterSortWidget(
                              changeSortOption: (WorkbookSortOption option) {
                                viewModel.changeFilterSortOption(option);
                              },
                            ),
                            const Gap(10),
                            WorkbookFilterBookmarkWidget(
                              toggleBookmark: () {
                                viewModel.toggleFilterShowBookmark();
                              },
                            ),
                            const Gap(10),
                            WorkbookFilterTabBar(
                              toggleGridView: () {
                                viewModel.toggleFilterShowGridView();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.lightBlue,
                          border: Border(
                            top: BorderSide(
                              color: AppColor.lightGrayBorder,
                              width: 1,
                            ),
                            left: BorderSide(
                              color: AppColor.lightGrayBorder,
                              width: 1,
                            ),
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                          ),
                        ),
                        child: widget.navigationShell,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const Center(child: Text('페이지 로딩 실패')),
    );
  }

  Widget _sideBarTile(int index, String title, IconData icon) {
    final viewModel = ref.read(dashboardViewModelProvider.notifier);
    return ListTile(
      title: Text(
        title,
        style: AppTextStyle.bodyMedium.copyWith(
          color:
          _selectedIndex == index
              ? AppColor.primary
              : AppColor.mediumGray,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      tileColor:
      _selectedIndex == index
          ? AppColor.paleBlue
          : AppColor.white,
      leading: Icon(
        icon,
        color:
        _selectedIndex == index
            ? AppColor.primary
            : AppColor.mediumGray,
      ),
      onTap: () {
        viewModel.clearFolderId();
        _onTap(context, index);
      },
    );
  }

  void _onTap(BuildContext context, int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.navigationShell.goBranch(index);
  }
}
