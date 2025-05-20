import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/state/current_team_id_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';

class TeamListWidget extends ConsumerWidget {
  final void Function(int teamId) onClickTeam;
  final void Function() onCreateTeam;

  const TeamListWidget({
    super.key,
    required this.onClickTeam,
    required this.onCreateTeam,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamListAsync = ref.watch(getTeamsByCurrentUserProvider);
    final currentTeamId = ref.watch(currentTeamIdStateProvider);
    return teamListAsync.when(
      data: (result) {
        // 성공적으로 로드한 팀 목록
        final teamList = switch (result) {
          Success(data: final data) => data,
          Error() => <Team>[],
        };

        // 드롭다운에 넣을 아이템 생성
        final items = [
          // 기존 팀들
          ...teamList.map((team) {
            return DropdownMenuItem<int>(
              value: team.teamId,
              child: Text(team.teamName, style: AppTextStyle.bodyMedium),
            );
          }),

          // 맨 아래에 새 팀 만들기 버튼 추가
          DropdownMenuItem<int>(
            value: -1, // 특별한 값 설정
            child: Row(
              children: [
                const Icon(Icons.group_add_outlined, color: AppColor.primary),
                const Gap(8),
                Text('팀 추가하기', style: AppTextStyle.bodyMedium.copyWith(color: AppColor.primary)),
              ],
            ),
          ),
        ];

        return Container(
          color: AppColor.white,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: DropdownButton<int>(
            value: currentTeamId,
            hint: const Text(
              '선택된 팀이 없습니다',
              style: TextStyle(color: AppColor.black),
            ),
            items: items,
            onChanged: (int? teamId) {
              if (teamId == null) return;
              if (teamId == -1) {
                onCreateTeam();
              } else {
                onClickTeam(teamId);
              }
            },
            underline: const SizedBox(),
            isExpanded: true,
            style: AppTextStyle.bodyMedium,
            dropdownColor: AppColor.white,
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColor.black),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
