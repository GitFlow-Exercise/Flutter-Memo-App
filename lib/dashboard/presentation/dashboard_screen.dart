import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/core/state/workbook_sort_option_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/dashboard/presentation/component/button_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/folder_list_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/team_list_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_sort_dropdown_widget.dart';
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
                SizedBox(
                  width: 250,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          color: AppColor.white,
                          height: 60,
                          child: Center(
                            child: Row(
                              children: [
                                Text('Mongo AI', style: AppTextStyle.titleBold.copyWith(color: AppColor.primary),),
                              ],
                          )),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColor.white,
                            border: Border(
                              right: BorderSide(
                                width: 1,
                                color: AppColor.lightGrayBorder
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TeamListWidget(
                                  currentTeamId: dashboard.currentTeamId,
                                  onClickTeam: (int teamId) {
                                    viewModel.selectTeam(teamId);
                                  },
                                ),
                                const Divider(height: 32, thickness: 1, color: AppColor.lightGrayBorder),
                                ListTile(
                                  title: const Text('내 항목'),
                                  leading: Icon(
                                    Icons.person,
                                    color: _selectedIndex == 0 ? AppColor.primary : AppColor.black,
                                  ),
                                  onTap: () {
                                    viewModel.clearFolder();
                                    _onTap(context, 0);
                                  }
                                ),
                                ListTile(
                                  title: const Text('최근 항목'),
                                  leading: Icon(
                                    Icons.timelapse,
                                    color: _selectedIndex == 1 ? AppColor.primary : AppColor.black,
                                  ),
                                  onTap: () {
                                    viewModel.clearFolder();
                                    _onTap(context, 1);
                                  }
                                ),
                                const Divider(height: 32, thickness: 1, color: AppColor.lightGrayBorder),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('폴더', style: AppTextStyle.bodyMedium),
                                    IconButton(
                                      onPressed: () {

                                      },
                                      icon: const Icon(Icons.add),
                                    )
                                  ],
                                ),
                                FolderListWidget(
                                  onClickFolder: (int folderId) {
                                    viewModel.selectFolder(folderId);
                                    _onTap(context, 2);
                                  },
                                  onClickExpand: () {

                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          decoration: const BoxDecoration(
                            color: AppColor.white,
                          ),
                          child: Row(
                            children: [
                              Text(dashboard.userProfile.userName, style: AppTextStyle.headingMedium.copyWith(fontWeight: FontWeight.bold)),
                              Text(' 님 환영합니다', style: AppTextStyle.headingMedium),
                              const Spacer(),
                              ButtonWidget(
                                buttonText: '새로 만들기',
                                icon: const Icon(Icons.auto_awesome, color: AppColor.white),
                                onClick: () {
                                  context.push(Routes.create);
                                }
                              ),
                              const SizedBox(width: 10),
                              ButtonWidget(
                                  buttonText: '문서 병합하기',
                                  icon: const Icon(Icons.layers, color: AppColor.white),
                                  onClick: () {}
                              ),
                            ],
                          ),
                        ),
                        WorkbookSortDropdownWidget(
                          onChanged: (WorkbookSortOption option) {
                            viewModel.changeSortOption(option);
                          },
                        ),
                        Expanded(
                          child: widget.navigationShell
                        ),
                      ],
                    ),
                  )
                ),
              ],
            )
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const Center(child: Text('페이지 로딩 실패')),
    );
  }

  void _onTap(BuildContext context, int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.navigationShell.goBranch(index);
  }
}
