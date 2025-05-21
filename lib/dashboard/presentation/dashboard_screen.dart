import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/enum/workbook_sort_option.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/core/state/current_team_id_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/dashboard/domain/model/folder.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/component/button/button_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/button/clean_trash_button.dart';
import 'package:mongo_ai/dashboard/presentation/component/button/delete_mode_button_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/button/merge_button_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/button/restore_button_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/button/select_mode_button_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/delete_workbook_alert_dialog.dart';
import 'package:mongo_ai/dashboard/presentation/component/folder_list_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/path_widget.dart';
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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(dashboardViewModelProvider.notifier).fetchSelectedTeam());
    });

    FirebaseAnalytics.instance.setUserId(
      id: ref.read(authRepositoryProvider).userId
    );

    ref.listenManual<int?>(
      currentTeamIdStateProvider,
          (previous, next) {
        FirebaseAnalytics.instance.setUserProperty(
          name: 'team_id',
          value: next?.toString() ?? 'no_team',
        );
        print('팀 아이디: $next');
      },
      fireImmediately: true, // 초기값도 한 번 처리
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardViewModelProvider);
    final selectedIndex = widget.navigationShell.currentIndex;
    if (selectedIndex == 0) {
      _currentPath = ['내 항목'];
    } else if (selectedIndex == 1) {
      _currentPath = ['최근 항목'];
    } else if (selectedIndex == 3) {
      _currentPath = ['휴지통'];
    } else if(selectedIndex == 4) {
      _currentPath = ['내 정보'];
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
                      child: Row(
                        children: [
                          _filterBar(),
                          const Spacer(),
                          selectedIndex == 3
                              ? _trashButtonBar(dashboard.currentTeamId)
                              : _buttonBar(dashboard.currentTeamId)
                        ],
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: Container(
                        clipBehavior: Clip.hardEdge,
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

  Widget _filterBar() {
    final viewModel = ref.read(dashboardViewModelProvider.notifier);
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
        ],
      ),
    );
  }

  Widget _buttonBar(int? currentTeamId) {
    final viewModel = ref.read(dashboardViewModelProvider.notifier);
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              height: 40,
              child: ButtonWidget(
                  onClick: () {
                    if(currentTeamId != null) {
                      context.go(Routes.create);
                    }
                  },
                  icon: Icons.auto_awesome,
                  text: '새로 만들기'
              )
          ),
          const Gap(10),
          MergeButtonWidget(
            onMerge: () {
              print('onMerge');
            },
            onToggleSelectMode: () {
              if(currentTeamId != null) {
                viewModel.toggleSelectMode();
              }
            },
          ),
          const Gap(10),
          SelectModeButtonWidget(
            onToggleSelectMode: () {
              if(currentTeamId != null) {
                viewModel.toggleSelectMode();
              }
            },
          )
        ],
      ),
    );
  }

  Widget _trashButtonBar(int? currentTeamId) {
    final viewModel = ref.read(dashboardViewModelProvider.notifier);
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          RestoreButtonWidget(
            onRestoreAll: () {
              if(currentTeamId != null) {
                viewModel.selectAll();
                viewModel.toggleDeleteMode();
              }
            },
            onRestoreSelected: () {
              if(currentTeamId != null) {
                viewModel.restoreWorkbookList();
                viewModel.toggleDeleteMode();
              }
            }
          ),
          const Gap(10),
          CleanTrashButton(
            onCleanAll: () {
              if(currentTeamId != null) {
                viewModel.selectAll();
                viewModel.toggleDeleteMode();
              }
            },
            onDeleteSelected: () {
              if(currentTeamId != null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DeleteWorkbookAlertDialog(
                      onDeleteWorkbook: () {
                        viewModel.deleteWorkbookList();
                        viewModel.toggleDeleteMode();
                      },
                      title: '문제집 삭제하기',
                    );
                  },
                );
              }
            },
          ),
          const Gap(10),
          DeleteModeButtonWidget(
            onToggleDeleteMode: () {
              if(currentTeamId != null) {
                viewModel.toggleDeleteMode();
              }
            }
          )
        ],
      ),
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
                onCreateTeam: () {
                  context.go(Routes.selectTeam);
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
                onCreateFolder: (String folderName) {
                  viewModel.createFolder(folderName);
                },
                onEditFolder: (Folder folder) {
                  viewModel.updateFolder(folder);
                },
                onDeleteFolder: (Folder folder) {
                  viewModel.deleteFolder(folder);
                },
                onChangeFolderWorkbookList: (int folderId) {
                  viewModel.changeFolderWorkbookList(folderId);
                },
              ),
            ),
            const Divider(color: AppColor.lightGrayBorder, thickness: 1),
            DragTarget<List<Workbook>>(
              onWillAcceptWithDetails: (details) {
                return details.data.isNotEmpty;
              },
              onAcceptWithDetails: (details) {
                viewModel.moveTrashWorkbookList();
              },
              builder: (context, candidateData, rejectedData) {
                final isHover = candidateData.isNotEmpty;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isHover ? AppColor.primary : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _sideBarTile(
                    selectedIndex,
                    3,
                    '휴지통',
                    Icons.delete,
                  ),
                );
              },
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  Widget _sideBarTile(
    int selectedIndex,
    int index,
    String title,
    IconData icon,
  ) {
    final viewModel = ref.read(dashboardViewModelProvider.notifier);
    return ListTile(
      title: Text(
        title,
        style: AppTextStyle.bodyMedium.copyWith(
          color:
              index == selectedIndex ? AppColor.primary : AppColor.mediumGray,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: index == selectedIndex ? AppColor.paleBlue : AppColor.white,
      leading: Icon(
        icon,
        color: index == selectedIndex ? AppColor.primary : AppColor.mediumGray,
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
