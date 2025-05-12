import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/dashboard/domain/model/folder.dart';
import 'package:mongo_ai/dashboard/presentation/component/folder_list_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/team_list_widget.dart';
import 'package:mongo_ai/dashboard/presentation/controller/dashboard_view_model.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardScreen({super.key, required this.navigationShell});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
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
                                const Divider(height: 32, thickness: 1),
                                ElevatedButton(
                                  onPressed: () => _onTap(context, 0),
                                  child: const Text('Home'),
                                ),
                                ElevatedButton(
                                  onPressed: () => _onTap(context, 1),
                                  child: const Text('Recent Files'),
                                ),
                                const Divider(height: 32, thickness: 1),
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
                                  onClickFolder: (List<Folder> path) {
                                    viewModel.selectFolder(path);
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
                              Text(dashboard.userProfile.userName, style: AppTextStyle.headingMedium.copyWith()),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  context.push(Routes.create);
                                },
                                child: const Text('새로 만들기'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                },
                                child: const Text('문서 병합하기'),
                              )
                            ],
                          ),
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
    widget.navigationShell.goBranch(index);
  }
}
