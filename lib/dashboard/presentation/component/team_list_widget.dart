import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/style/app_color.dart';

class TeamListWidget extends ConsumerWidget {
  final void Function(int teamId) onClickTeam;
  final int? currentTeamId;

  const TeamListWidget({
    super.key,
    required this.onClickTeam,
    required this.currentTeamId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamList = ref.watch(getTeamsByCurrentUserProvider);
    return Container(
      color: AppColor.white,
      child: teamList.when(
        data: (result) {
          return switch (result) {
            Success(data: final data) => SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final team = data[index];
                  return ListTile(
                    title: Text(
                      team.teamName,
                      style: TextStyle(
                        color: currentTeamId == team.teamId
                            ? Colors.cyan
                            : AppColor.black,
                      ),
                    ),
                    onTap: () => onClickTeam(team.teamId),
                  );
                },
              ),
            ),
            Error() => const SizedBox.shrink(),
          };
        },
        loading: () => const SizedBox.shrink(),
        error: (e, _) => const SizedBox.shrink(),
      ),
    );
  }
}
