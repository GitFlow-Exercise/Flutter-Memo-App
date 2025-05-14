import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/auth/presentation/select_team/controller/select_team_action.dart';
import 'package:mongo_ai/auth/presentation/select_team/controller/select_team_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';

class SelectTeamScreen extends StatefulWidget {
  final SelectTeamState state;
  final void Function(SelectTeamAction action) onAction;

  const SelectTeamScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  State<SelectTeamScreen> createState() => _SelectTeamScreenState();
}

class _SelectTeamScreenState extends State<SelectTeamScreen> {
  static const double _breakpoint = 1100.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Column(
        children: [
          // 헤더
          Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: AppColor.white,
                border: Border(
                  bottom: BorderSide(color: AppColor.lightGrayBorder),
                ),
              ),
              child: SizedBox(
                height: 30,
                child: Center(
                  child: Row(
                    children: [
                      Text(
                        'Mongo AI',
                        style: AppTextStyle.titleBold.copyWith(
                          color: AppColor.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ),

          // 본문
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // 화면 너비에 따른 레이아웃 결정
                final isWideScreen = constraints.maxWidth >= _breakpoint;

                if (isWideScreen) {
                  // 넓은 화면: 두 개의 컬럼 (메인 콘텐츠 + 정보 패널)
                  return Row(
                    children: [
                      // 왼쪽 메인 영역
                      Expanded(
                        flex: 3,
                        child: _buildMainContent(),
                      ),
                      // 오른쪽 정보 영역
                      Expanded(
                        flex: 2,
                        child: _buildInfoPanel(),
                      ),
                    ],
                  );
                } else {
                  // 좁은 화면: 메인 콘텐츠만 가운데 정렬
                  return Center(
                    child: SingleChildScrollView(
                      child: _buildMainContent(showInfoInSmallScreen: true),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent({bool showInfoInSmallScreen = false}) {
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
              _buildTeamSelector(),
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
              _buildTeamCreator(),
              const Gap(40),

              // 확인 버튼
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => widget.onAction(const SelectTeamAction.onConfirm()),
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

              if (showInfoInSmallScreen) ...[
                const Gap(32),
                const Divider(height: 1, color: AppColor.lightGrayBorder),
                const Gap(16),
                _buildSmallScreenInfoSummary(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // 작은 화면에서 표시할 간단한 정보 요약
  Widget _buildSmallScreenInfoSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 16,
              color: Colors.blue.withValues(alpha: 0.8),
            ),
            const Gap(8),
            const Text(
              '팀 설정 안내',
              style: TextStyle(
                fontFamily: AppTextStyle.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.mediumGray,
              ),
            ),
          ],
        ),
        const Gap(12),
        _buildSimpleInfoItem(
          icon: Icons.people_outline,
          text: '팀원들과 문제집을 공유하고 함께 작업할 수 있습니다.',
        ),
        const Gap(8),
        _buildSimpleInfoItem(
          icon: Icons.folder_outlined,
          text: '체계적인 폴더 시스템으로 자료를 효율적으로 관리하세요.',
        ),
        const Gap(8),
        _buildSimpleInfoItem(
          icon: Icons.update,
          text: '팀원들과 실시간으로 의견을 나누고 피드백을 주고받을 수 있습니다.',
        ),
        const Gap(12),
        Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 16,
              color: Colors.amber.withValues(alpha: 0.8),
            ),
            const Gap(8),
            const Expanded(
              child: Text(
                '팀은 언제든지 변경하거나 새로 만들 수 있습니다.',
                style: TextStyle(
                  fontFamily: AppTextStyle.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColor.paleGray,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 작은 화면용 간단한 정보 항목
  Widget _buildSimpleInfoItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColor.primary,
        ),
        const Gap(8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: AppTextStyle.fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColor.lightGray,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border.all(color: AppColor.lightGrayBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: widget.state.teams.when(
        data: (teams) {
          return DropdownButtonHideUnderline(
            child: DropdownButton<Team>(
              value: widget.state.isCreatingNewTeam ? null : widget.state.selectedTeam,
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
                  widget.onAction(SelectTeamAction.onSelectTeam(team));
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
    );
  }

  Widget _buildTeamCreator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          controller: widget.state.teamNameController,
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
          onChanged: (value) {
            widget.onAction(SelectTeamAction.onChangeTeamName(value));
          },
        ),
        const Gap(8),
        InkWell(
          onTap: () => widget.onAction(const SelectTeamAction.onCreateTeam()),
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
    );
  }

  Widget _buildInfoPanel() {
    return Container(
      padding: const EdgeInsets.all(40),
      color: AppColor.paleBlue,
      child: Center(
        child: Container(
          width: 450,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '팀 설정 안내',
                    style: TextStyle(
                      fontFamily: AppTextStyle.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColor.mediumGray,
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const Gap(24),
              _buildInfoItem(
                iconColor: Colors.purple.withValues(alpha: 0.2),
                iconData: Icons.people_outline,
                title: '문제집 공유',
                description: '팀원들과 문제집을 공유하고 함께 작업할 수 있습니다.',
              ),
              const Gap(16),
              _buildInfoItem(
                iconColor: Colors.teal.withValues(alpha: 0.2),
                iconData: Icons.folder_outlined,
                title: '자료 관리',
                description: '체계적인 폴더 시스템으로 자료를 효율적으로 관리하세요.',
              ),
              const Gap(16),
              _buildInfoItem(
                iconColor: Colors.amber.withValues(alpha: 0.2),
                iconData: Icons.update,
                title: '실시간 협업',
                description: '팀원들과 실시간으로 의견을 나누고 피드백을 주고받을 수 있습니다.',
              ),
              const Gap(24),
              const Divider(height: 1, color: AppColor.lightGrayBorder),
              const Gap(16),
              Row(
                children: [
                  const Text(
                    '팀은 언제든지 변경하거나 새로 만들 수 있습니다.',
                    style: TextStyle(
                      fontFamily: AppTextStyle.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.paleGray,
                    ),
                  ),
                  const Gap(6),
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: Colors.amber.withValues(alpha: 0.8),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required Color iconColor,
    required IconData iconData,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            iconData,
            size: 18,
            color: iconColor,
          ),
        ),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: AppTextStyle.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColor.mediumGray,
                ),
              ),
              const Gap(4),
              Text(
                description,
                style: const TextStyle(
                  fontFamily: AppTextStyle.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColor.lightGray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}