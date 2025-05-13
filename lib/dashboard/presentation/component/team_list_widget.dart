import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';

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
    final teamListAsync = ref.watch(getTeamsByCurrentUserProvider);
    return teamListAsync.when(
      data: (result) {
        // 성공적으로 로드한 팀 목록
        final teamList = switch (result) {
          Success(data: final data) => data,
          Error() => <Team>[],
        };
        final int? value = currentTeamId;

        return Container(
          decoration: BoxDecoration(
            color: AppColor.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: DropdownButton<int>(
            value: value,
            hint: const Text('선택된 팀이 없습니다', style: TextStyle(color: AppColor.black),),
            onChanged: (int? teamId) {
              if (teamId != null) onClickTeam(teamId);
            },
            underline: const SizedBox(), // 밑줄 안그리기
            isExpanded: true,
            style: AppTextStyle.bodyMedium,
            dropdownColor: AppColor.white,
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColor.black),

            // 드롭다운 텍스트
            items: teamList.map((team) {
              return DropdownMenuItem<int>(
                value: team.teamId,
                child: Text(team.teamName, style: AppTextStyle.bodyMedium),
              );
            }).toList(),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
