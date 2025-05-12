import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/routing/routes.dart';
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
            appBar: AppBar(
              title: const Text('Mongo AI'),
              actions: [
                Text(
                  dashboard.userProfile.userName,
                ),
              ],
            ),
            body: Row(
              children: [
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
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
                      const Text('폴더'),
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
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context.push(Routes.create);
                            },
                            child: const Text('새로 만들기'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              viewModel.refreshFolderList();
                            },
                            child: const Text('폴더 새로고침'),
                          )
                        ],
                      ),
                      Expanded(
                        child: widget.navigationShell
                      ),
                    ],
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
