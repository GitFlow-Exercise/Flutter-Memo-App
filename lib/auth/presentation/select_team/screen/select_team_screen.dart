import 'package:flutter/material.dart';
import 'package:mongo_ai/auth/presentation/components/select_team_info_panel.dart';
import 'package:mongo_ai/auth/presentation/components/select_team_main_content_panel.dart';
import 'package:mongo_ai/auth/presentation/select_team/controller/select_team_action.dart';
import 'package:mongo_ai/auth/presentation/select_team/controller/select_team_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

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
            ),
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
                        child: MainContentPanel(
                          state: widget.state,
                          onAction: widget.onAction,
                        ),
                      ),
                      // 오른쪽 정보 영역
                      const Expanded(flex: 2, child: SelectTeamInfoPanel()),
                    ],
                  );
                } else {
                  // 좁은 화면: 메인 콘텐츠만 가운데 정렬
                  return Center(
                    child: SingleChildScrollView(
                      child: MainContentPanel(
                        state: widget.state,
                        onAction: widget.onAction,
                        showInfoInSmallScreen: true,
                      ),
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
}
