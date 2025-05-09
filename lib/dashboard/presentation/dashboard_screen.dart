import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';
import 'package:mongo_ai/dashboard/presentation/dashboard_view_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    return dashboardAsync.when(
      data: (dashboard) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Mongo AI'),
              actions: [
                switch (dashboard.userProfileResult) {
                  Success(data: final userProfile) => Text(
                    userProfile.userName,
                  ),
                  Error(error: final error) => const Text(
                    '이름 로딩중...'
                  ),
                },
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
                      switch (dashboard.teamsResult) {
                        Success(data: final List<Team> teams) => SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: teams.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(teams[index].teamName),
                                onTap: () {},
                              );
                            },
                          ),
                        ),
                        Error(error: final error) => const Text(
                            '이름 로딩중...'
                        ),
                      },
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
                          ElevatedButton(
                            onPressed: () {
                              ref.read(dashboardViewModelProvider.notifier).refreshAll();
                            },
                            child: const Text('새로고침'),
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
