import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/domain/model/folder.dart';

class FolderListWidget extends ConsumerWidget {
  final void Function(List<Folder> path) onClickFolder;
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
                  title: Text(folder.folderName),
                  onTap: () {
                    onClickFolder([folder]);
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