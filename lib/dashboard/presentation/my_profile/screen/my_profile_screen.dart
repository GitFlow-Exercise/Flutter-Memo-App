import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/dashboard/presentation/component/delete_account_alert_dialog.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/controller/my_profile_action.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/controller/my_profile_state.dart';

class MyProfileScreen extends StatefulWidget {
  final MyProfileState state;
  final void Function(MyProfileAction action) onAction;
  final String teamName;

  const MyProfileScreen({
    super.key,
    required this.state,
    required this.onAction,
    required this.teamName,
  });

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void didUpdateWidget(covariant MyProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.userNameController.text != widget.state.data.value?.userName) {
      widget.state.userNameController.text = widget.state.data.value?.userName ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBlue,
      body: Center(
        child: widget.state.data.when(
          data: (profile) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 사용자 정보 카드
                        Container(
                          width: 500,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                            border: Border.all(color: AppColor.lightGrayBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 카드 제목
                              Text(
                                '사용자 정보',
                                style: AppTextStyle.headingMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.deepBlack,
                                ),
                              ),
                              const Gap(16),
                              // 사용자 기본 정보
                              Text(
                                profile.userName,
                                style: AppTextStyle.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: AppColor.deepBlack,
                                ),
                              ),
                              const Gap(12),
                              Text(
                                widget.teamName,
                                style: AppTextStyle.bodyRegular.copyWith(
                                  color: AppColor.lightGray,
                                ),
                              ),
                              const Gap(24),

                              // 이름 수정 폼
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '이름 수정',
                                      style: AppTextStyle.headingMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.deepBlack,
                                      ),
                                    ),
                                    const Gap(16),
                                    TextFormField(
                                      controller: widget.state.userNameController,
                                      style: AppTextStyle.bodyRegular.copyWith(
                                        color: AppColor.deepBlack,
                                      ),
                                      decoration: InputDecoration(
                                        fillColor: AppColor.white,
                                        filled: true,
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide: const BorderSide(
                                            color: AppColor.lightGrayBorder,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide: const BorderSide(
                                            color: AppColor.lightGrayBorder,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide: const BorderSide(
                                            color: AppColor.primary,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return '이름을 입력해주세요';
                                        }
                                        return null;
                                      },
                                    ),
                                    const Gap(24),
                                    // 저장 버튼
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: SizedBox(
                                        height: 40,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!.validate()) {
                                              widget.onAction(
                                                MyProfileAction.onUpdateProfile(
                                                  widget
                                                      .state
                                                      .userNameController
                                                      .text,
                                                ),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColor.primary,
                                            foregroundColor: AppColor.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                          ),
                                          child: const Text('저장'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Gap(24),

                        // 계정 관리 카드
                        Container(
                          width: 500,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                            border: Border.all(color: AppColor.lightGrayBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 카드 제목
                              Text(
                                '계정 관리',
                                style: AppTextStyle.headingMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.deepBlack,
                                ),
                              ),
                              const Gap(16),
                              // 로그아웃 섹션
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '로그아웃',
                                    style: AppTextStyle.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.mediumGray,
                                    ),
                                  ),
                                  const Gap(4),
                                  Text(
                                    '현재 기기에서 로그아웃합니다.',
                                    style: AppTextStyle.captionRegular.copyWith(
                                      color: AppColor.lightGray,
                                    ),
                                  ),
                                  const Gap(12),
                                  OutlinedButton(
                                    onPressed: () {
                                      widget.onAction(
                                        const MyProfileAction.onLogout(),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColor.mediumGray,
                                      side: const BorderSide(
                                        color: AppColor.lightGrayBorder,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                    child: const Text('로그아웃'),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Divider(
                                  height: 1,
                                  color: AppColor.lightGrayBorder,
                                ),
                              ),
                              // 회원 탈퇴 섹션
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '회원 탈퇴',
                                    style: AppTextStyle.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.destructive,
                                    ),
                                  ),
                                  const Gap(4),
                                  Text(
                                    '모든 데이터가 영구적으로 삭제됩니다. 이 작업은 되돌릴 수 없습니다.',
                                    style: AppTextStyle.captionRegular.copyWith(
                                      color: AppColor.lightGray,
                                    ),
                                  ),
                                  const Gap(12),
                                  OutlinedButton(
                                    onPressed: () {
                                      // 회원 탈퇴 확인 다이얼로그
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DeleteAccountAlertDialog(
                                            onDeleteAccount: () {
                                              widget.onAction(
                                                const MyProfileAction.onDeleteAccount(),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColor.destructive,
                                      side: const BorderSide(
                                        color: AppColor.destructive,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                    child: const Text('회원 탈퇴'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => const Text('프로필 정보를 불러오는데 실패했습니다.'),
        ),
      ),
    );
  }
}
