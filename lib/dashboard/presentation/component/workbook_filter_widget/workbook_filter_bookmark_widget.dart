import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/state/workbook_filter_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';

class WorkbookFilterBookmarkWidget extends ConsumerWidget {
  final void Function() toggleBookmark;

  const WorkbookFilterBookmarkWidget({super.key, required this.toggleBookmark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showBookmark = ref.watch(workbookFilterStateProvider).showBookmark;

    return IconButton(
      icon:
          showBookmark
              ? const Icon(Icons.star, color: AppColor.secondary)
              : const Icon(Icons.star_border),
      onPressed: () => toggleBookmark(),
      tooltip: showBookmark ? '북마크 해제' : '북마크만 보기',
    );
  }
}
