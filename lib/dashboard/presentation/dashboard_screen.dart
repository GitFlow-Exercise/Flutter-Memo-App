import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/enum/workbook_sort_option.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/dashboard/domain/model/folder.dart';
import 'package:mongo_ai/dashboard/presentation/component/button_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/folder_list_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/path_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/select_mode_button_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/team_list_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_filter_widget/workbook_filter_bookmark_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_filter_widget/workbook_filter_sort_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_filter_widget/workbook_filter_tab_bar.dart';
import 'package:mongo_ai/dashboard/presentation/controller/dashboard_view_model.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardScreen({super.key, required this.navigationShell});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  List<String> _currentPath = [];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardViewModelProvider);
    final viewModel = ref.read(dashboardViewModelProvider.notifier);
    final selectedIndex = widget.navigationShell.currentIndex;
    if(selectedIndex == 0) {
      _currentPath = ['내 항목'];
    } else if(selectedIndex == 1) {
      _currentPath = ['최근 항목'];
    } else if(selectedIndex == 3) {
      _currentPath = ['휴지통'];
    }

    return state.when(
      data: (dashboard) {
        return Scaffold(
          backgroundColor: AppColor.white,
          body: Row(
            children: [
              _sideBar(selectedIndex),
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
                            PathWidget(path: _currentPath),
                            const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            context.go(Routes.myProfile);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.white,
                            shadowColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person,
                                color: AppColor.deepBlack,
                              ),
                              const Gap(10),
                              Text(
                                dashboard.userProfile.userName,
                                style: AppTextStyle.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.black
                                ),
                              ),
                            ],
                          ),
                        ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: SizedBox(
                        height: 40,
                        child: Row(
                          children: [
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
                              toggleGridView: (bool showGridView) {
                                viewModel.toggleFilterShowGridView(
                                  showGridView,
                                );
                              },
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 40,
                              child: ButtonWidget(
                                onClick: () {
                                  if(dashboard.currentTeamId != null) {
                                    context.go(Routes.create);
                                  }
                                },
                                text: '새로 만들기',
                                icon: Icons.auto_awesome,
                              )
                            ),
                            const Gap(10),
                            SizedBox(
                              height: 40,
                              child: SelectModeButtonWidget(
                                onClick: () {
                                  if(dashboard.currentTeamId != null) {
                                    viewModel.toggleSelectMode();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
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
                          borderRadius: BorderRadius.only(
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

  Widget _sideBar(int selectedIndex) {
    final viewModel = ref.read(dashboardViewModelProvider.notifier);
    return SizedBox(
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
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.primary,
                      ),
                      child: Center(
                        child: Image.asset(
                          'images/mongo_ai_logo.png',
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                    const Gap(10),
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
                onClickTeam: (int teamId) {
                  viewModel.selectTeam(teamId);
                },
              ),
            ),
            const Gap(10),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColor.lightGrayBorder, width: 1),
                  top: BorderSide(color: AppColor.lightGrayBorder, width: 1),
                ),
              ),
              child: Column(
                children: [
                  const Gap(10),
                  _sideBarTile(selectedIndex, 0, '내 항목', Icons.person),
                  const Gap(10),
                  _sideBarTile(selectedIndex, 1, '최근 항목', Icons.timelapse),
                  const Gap(10),
                ],
              ),
            ),
            const Gap(10),
            Expanded(
              child: FolderListWidget(
                onClickFolder: (Folder folder) {
                  viewModel.selectFolderId(folder.folderId);
                  _onTap(context, 2);
                  setState(() {
                    _currentPath = [folder.folderName];
                  });
                },
                onClickExpand: () {},
                onCreateFolder: (String folderName) {
                  viewModel.createFolder(folderName);
                },
                onEditFolder: (Folder folder) {
                  viewModel.updateFolder(folder);
                },
                onDeleteFolder: (Folder folder) {
                  viewModel.deleteFolder(folder);
                },
              ),
            ),
            const Divider(
              color: AppColor.lightGrayBorder,
              thickness: 1,
            ),
            _sideBarTile(selectedIndex, 3, '휴지통', Icons.delete),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  Widget _sideBarTile(int selectedIndex, int index, String title, IconData icon) {
    final viewModel = ref.read(dashboardViewModelProvider.notifier);
    return ListTile(
      title: Text(
        title,
        style: AppTextStyle.bodyMedium.copyWith(
          color:
          index == selectedIndex
              ? AppColor.primary
              : AppColor.mediumGray,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      tileColor:
      index == selectedIndex
          ? AppColor.paleBlue
          : AppColor.white,
      leading: Icon(
        icon,
        color:
        index == selectedIndex
            ? AppColor.primary
            : AppColor.mediumGray,
      ),
      onTap: () {
        viewModel.clearFolderId();
        _onTap(context, index);
        setState(() {
          _currentPath = [title];
        });
      },
    );
  }

  void _onTap(BuildContext context, int index) {
    widget.navigationShell.goBranch(index);
  }
}
