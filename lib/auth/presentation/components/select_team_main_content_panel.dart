import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/auth/presentation/components/select_team_small_screen_info_summary.dart';
import 'package:mongo_ai/auth/presentation/select_team/controller/select_team_action.dart';
import 'package:mongo_ai/auth/presentation/select_team/controller/select_team_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';

class MainContentPanel extends StatelessWidget {
  final SelectTeamState state;
  final void Function(SelectTeamAction action) onAction;
  final bool showInfoInSmallScreen;

  const MainContentPanel({
    super.key,
    required this.state,
    required this.onAction,
    this.showInfoInSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.lightBlue,
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '팀을 선택하거나 새로 만들어보세요',
                style: TextStyle(
                  fontFamily: AppTextStyle.fontFamily,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColor.deepBlack,
                ),
              ),
              const Gap(32),

              // 기존 팀 선택 영역
              const Text(
                '기존 팀 선택',
                style: TextStyle(
                  fontFamily: AppTextStyle.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.paleGray,
                ),
              ),
              const Gap(8),
              // 팀 선택 드롭다운
              Container(
                decoration: BoxDecoration(
                  color: AppColor.white,
                  border: Border.all(color: AppColor.lightGrayBorder),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: state.teams.when(
                  data: (teams) {
                    if (teams.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: const Text(
                          '선택 가능한 팀이 없습니다. 팀을 새로 만들어보세요',
                          style: TextStyle(
                            fontFamily: AppTextStyle.fontFamily,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColor.lightGray,
                          ),
                        ),
                      );
                    }

                    return DropdownButtonHideUnderline(
                      child: DropdownButton<Team>(
                        value: state.isCreatingNewTeam ? null : state.selectedTeam,
                        isExpanded: true,
                        hint: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '팀을 선택하세요',
                            style: TextStyle(
                              fontFamily: AppTextStyle.fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColor.paleGray,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        icon: const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(Icons.keyboard_arrow_down, color: AppColor.paleGray),
                        ),
                        items: teams.map((team) {
                          return DropdownMenuItem<Team>(
                            value: team,
                            child: Text(
                              team.teamName,
                              style: const TextStyle(
                                fontFamily: AppTextStyle.fontFamily,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColor.deepBlack,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (team) {
                          if (team != null) {
                            onAction(SelectTeamAction.onSelectTeam(team));
                          }
                        },
                      ),
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, stack) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Center(
                      child: Text(
                        '팀 정보를 불러오는데 실패했습니다',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(8),

              // 구분선 영역
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColor.lightGrayBorder,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '또는',
                      style: TextStyle(
                        fontFamily: AppTextStyle.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.paleGray,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColor.lightGrayBorder,
                    ),
                  ),
                ],
              ),
              const Gap(16),

              // 새 팀 만들기 영역
              const Text(
                '새 팀 만들기',
                style: TextStyle(
                  fontFamily: AppTextStyle.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.paleGray,
                ),
              ),
              const Gap(8),
              // 팀 생성 입력 필드와 버튼
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: state.teamNameController,
                    decoration: InputDecoration(
                      hintText: '팀 이름을 입력하세요',
                      hintStyle: const TextStyle(
                        fontFamily: AppTextStyle.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColor.paleGray,
                      ),
                      filled: true,
                      fillColor: AppColor.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColor.lightGrayBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColor.lightGrayBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColor.primary),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const Gap(8),
                  InkWell(
                    onTap: () => onAction(const SelectTeamAction.onCreateTeam()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Icon(
                              Icons.add_circle_outline,
                              size: 20,
                              color: AppColor.primary.withValues(alpha: 0.8),
                            ),
                          ),
                          const Gap(6),
                          Text(
                            '새 팀 생성하기',
                            style: TextStyle(
                              fontFamily: AppTextStyle.fontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColor.primary.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(40),

              // 확인 버튼
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => onAction(const SelectTeamAction.onConfirm()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: AppColor.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      fontFamily: AppTextStyle.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              if (state.isUserInAnyTeam)
                Column(
                  children: [
                    const Gap(16),

                    Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.lighterGray),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ElevatedButton(
                        onPressed: () => onAction(const SelectTeamAction.onCancel()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.white,
                          foregroundColor: AppColor.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          '취소',
                          style: AppTextStyle.bodyRegular.copyWith(color: AppColor.deepBlack)
                        ),
                      ),
                    ),
                  ],
                ),

              if (showInfoInSmallScreen) ...[
                const Gap(32),
                const Divider(height: 1, color: AppColor.lightGrayBorder),
                const Gap(16),
                const SmallScreenInfoSummary(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}