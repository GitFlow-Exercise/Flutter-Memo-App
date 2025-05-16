import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/controller/my_profile_action.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/controller/my_profile_state.dart';

class MyProfileScreen extends StatefulWidget {
  final MyProfileState state;
  final void Function(MyProfileAction action) onAction;

  const MyProfileScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateNameController();
  }

  @override
  void didUpdateWidget(MyProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != oldWidget.state) {
      _updateNameController();
    }
  }

  void _updateNameController() {
    if (widget.state.data.hasValue && widget.state.data.value != null) {
      final profile = widget.state.data.value!;
      if (_nameController.text != profile.userName) {
        _nameController.text = profile.userName;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBlue,
      body: Center(
        child: widget.state.data.when(
          data: (profile) {
            // 현재 컨트롤러 텍스트가 profile.userName과 다르면 업데이트
            if (_nameController.text != profile.userName) {
              _nameController.text = profile.userName;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 사용자 정보 카드
                  _buildUserInfoCard(profile),
                  const Gap(24),
                  // 계정 관리 카드
                  _buildAccountManagementCard(),
                ],
              ),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('프로필 정보를 불러오는데 실패했습니다. 오류: $error'),
        ),
      ),
    );
  }

  // 사용자 정보 카드 위젯
  Widget _buildUserInfoCard(userProfile) {
    return Container(
      width: 500,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            userProfile.userName,
            style: AppTextStyle.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: AppColor.deepBlack,
            ),
          ),
          const Gap(8),
          Text(
            '국어팀', // 실제로는 API에서 받아와야 하는 값
            style: AppTextStyle.bodyRegular.copyWith(
              color: AppColor.lightGray,
            ),
          ),
          const Gap(4),
          // 이름 수정 폼
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '이름',
                  style: AppTextStyle.labelMedium.copyWith(
                    color: AppColor.mediumGray,
                  ),
                ),
                const Gap(8),
                TextFormField(
                  controller: _nameController,
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
                      borderSide: const BorderSide(color: AppColor.lightGrayBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: AppColor.lightGrayBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: AppColor.primary),
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
                        debugPrint('my_profile_screen.dart: 저장 버튼 클릭 - Line 159');
                        if (_formKey.currentState!.validate()) {
                          widget.onAction(MyProfileAction.onUpdateProfile(_nameController.text));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: AppColor.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
    );
  }

  // 계정 관리 카드 위젯
  Widget _buildAccountManagementCard() {
    return Container(
      width: 500,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  debugPrint('my_profile_screen.dart: 로그아웃 버튼 클릭 - Line 219');
                  widget.onAction(const MyProfileAction.onLogout());
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.mediumGray,
                  side: const BorderSide(color: AppColor.lightGrayBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  debugPrint('my_profile_screen.dart: 회원 탈퇴 버튼 클릭 - Line 255');
                  _showDeleteAccountConfirmationDialog();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.destructive,
                  side: const BorderSide(color: AppColor.destructive),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text('회원 탈퇴'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 회원 탈퇴 확인 다이얼로그
  void _showDeleteAccountConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('회원 탈퇴 확인'),
          content: const Text(
            '정말로 탈퇴하시겠습니까? 모든 데이터가 영구적으로 삭제되며, 이 작업은 되돌릴 수 없습니다.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                debugPrint('my_profile_screen.dart: 회원 탈퇴 확인 - Line 288');
                Navigator.of(context).pop(); // 다이얼로그 닫기
                widget.onAction(const MyProfileAction.onDeleteAccount());
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColor.destructive,
              ),
              child: const Text('탈퇴하기'),
            ),
          ],
        );
      },
    );
  }
}