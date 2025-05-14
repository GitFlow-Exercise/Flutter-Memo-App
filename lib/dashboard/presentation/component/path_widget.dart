import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/state/dashboard_path_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class PathWidget extends ConsumerWidget {
  const PathWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = ref.watch(dashboardPathStateProvider);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.home, color: AppColor.deepBlack),
        ...path.map((e) {
          return Row(
            children: [
              const Gap(10),
              const Icon(Icons.keyboard_arrow_right, color: AppColor.deepBlack),
              const Gap(10),
              Text(e, style: AppTextStyle.headingMedium.copyWith(fontWeight: FontWeight.bold, color: AppColor.deepBlack),),
            ],
          );
        }),
      ],
    );
  }
}
