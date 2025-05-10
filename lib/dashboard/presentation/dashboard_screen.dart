import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/routing/routes.dart';
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
    final dashboardAsync = ref.watch(dashboardViewModelProvider);
    final dashboardNotifier = ref.read(dashboardViewModelProvider.notifier);
    return dashboardAsync.when(
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
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: dashboard.teamList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(dashboard.teamList[index].teamName),
                              tileColor: dashboard.currentTeamId == dashboard.teamList[index].teamId ? Colors.blue : Colors.white,
                              onTap: () {
                                dashboardNotifier.selectTeam(dashboard.teamList[index].teamId);
                              },
                            );
                          },
                        ),
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
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: dashboard.folderList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(dashboard.folderList[index].folderName),
                              onTap: () {},
                            );
                          },
                        ),
                      ),
                      // folderProvider 자리
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
