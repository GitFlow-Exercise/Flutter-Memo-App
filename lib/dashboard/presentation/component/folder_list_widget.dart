import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/state/current_folder_id_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class FolderListWidget extends ConsumerWidget {
  final void Function(int folderId) onClickFolder;
  final void Function() onClickExpand;

  const FolderListWidget({
    super.key,
    required this.onClickFolder,
    required this.onClickExpand,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Todo : arguments 리팩토링 고민하기
    final folderList = ref.watch(getFoldersByCurrentTeamIdProvider);
    final currentFolderId = ref.watch(currentFolderIdStateProvider);
    return folderList.when(
      data: (result) {
        return switch (result) {
          Success(data: final data) => SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final folder = data[index];
                return ListTile(
                  title: Text(
                    folder.folderName,
                    style: AppTextStyle.bodyRegular.copyWith(
                      color:
                          folder.folderId == currentFolderId
                              ? AppColor.primary
                              : AppColor.mediumGray,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor:
                      folder.folderId == currentFolderId
                          ? AppColor.paleBlue
                          : AppColor.white,
                  leading: Icon(
                    Icons.folder,
                    color:
                        folder.folderId == currentFolderId
                            ? AppColor.primary
                            : AppColor.mediumGray,
                  ),
                  onTap: () {
                    onClickFolder(folder.folderId);
                  },
                );
              },
            ),
          ),
          Error() => const SizedBox.shrink(),
        };
      },
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}
