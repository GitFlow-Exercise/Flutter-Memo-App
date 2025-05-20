import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/landing/presentation/privacy_policies/controller/privacy_policies_state.dart';

class PrivacyPoliciesScreen extends StatefulWidget {
  final PrivacyPoliciesState state;

  const PrivacyPoliciesScreen({super.key, required this.state});

  @override
  State<PrivacyPoliciesScreen> createState() => _PrivacyPoliciesScreenState();
}

class _PrivacyPoliciesScreenState extends State<PrivacyPoliciesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.state.data.when(
        data: (privacyPolicies) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '개인정보처리방침',
                  style: AppTextStyle.titleBold.copyWith(
                    fontSize: 24,
                    color: AppColor.deepBlack,
                  ),
                ),
                const Gap(32),
                Text(
                  privacyPolicies.content,
                  style: AppTextStyle.bodyRegular.copyWith(
                    color: AppColor.mediumGray,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColor.primary),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColor.destructive,
                size: 48,
              ),
              const Gap(16),
              Text(
                '개인정보처리방침을 불러오는 중 오류가 발생했습니다.',
                style: AppTextStyle.bodyMedium.copyWith(color: AppColor.mediumGray),
              ),
              const Gap(8),
            ],
          ),
        ),
      ),
    );
  }
}