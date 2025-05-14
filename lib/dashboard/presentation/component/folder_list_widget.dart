import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/state/current_folder_id_state.dart';
import 'package:mongo_ai/core/state/current_team_id_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/dashboard/domain/model/folder.dart';

class FolderListWidget extends ConsumerStatefulWidget {
  final void Function(Folder folder) onClickFolder;
  final void Function(String folderName) onCreateFolder;
  final void Function(Folder folder) onEditFolder;
  final void Function(Folder folder) onDeleteFolder;
  final void Function() onClickExpand;

  const FolderListWidget({
    super.key,
    required this.onClickFolder,
    required this.onClickExpand,
    required this.onEditFolder,
    required this.onCreateFolder,
    required this.onDeleteFolder,
  });

  @override
  ConsumerState<FolderListWidget> createState() => _FolderListWidgetState();
}

class _FolderListWidgetState extends ConsumerState<FolderListWidget> {
  final _createController = TextEditingController();
  final _editController = TextEditingController();
  late final FocusNode _createFocusNode;
  late final FocusNode _editFocusNode;

  bool _isCreating = false;
  int? _editFolderId;

  @override
  void initState() {
    super.initState();
    // unfocus 시키면 폴더 생성 취소
    _createFocusNode = FocusNode()
      ..addListener(() {
        if (!_createFocusNode.hasFocus) {
          setState(() {
            _createController.clear();
            _isCreating = false;
          });
        }
      }
    );
    _editFocusNode = FocusNode()
      ..addListener(() {
        if (!_editFocusNode.hasFocus) {
          setState(() {
            _editController.clear();
            _editFolderId = null;
          });
        }
      });
  }

  @override
  void dispose() {
    _createFocusNode.dispose();
    _createController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Todo : arguments 리팩토링 고민하기
    final folderList = ref.watch(getFoldersByCurrentTeamIdProvider);
    final currentFolderId = ref.watch(currentFolderIdStateProvider);
    final currentTeamId = ref.read(currentTeamIdStateProvider);

    return folderList.when(
      data: (result) {
        return switch (result) {
          Success(data: final data) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('폴더', style: AppTextStyle.bodyMedium),
                  IconButton(
                    onPressed: () {
                      if(currentTeamId != null) {
                        setState(() {
                          _isCreating = true;
                          // 폴더 생성 시 textField에 Focus 주기
                          Future.microtask(() => _createFocusNode.requestFocus());
                        });
                      }
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    // -----------------------
                    // 폴더 생성
                    if (_isCreating)
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.create_new_folder,
                                color: AppColor.primary,
                              ),
                              const Gap(10),
                              Expanded(
                                child: TextField(
                                  controller: _createController,
                                  focusNode: _createFocusNode,
                                  decoration: const InputDecoration(
                                    hintText: '폴더 이름을 입력하세요',
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (value) {
                                    final name = value.trim();
                                    if (name.isNotEmpty) {
                                      widget.onCreateFolder(name);
                                    }

                                    setState(() {
                                      _createController.clear();
                                      _isCreating = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 0,
                            color: AppColor.primary,
                            thickness: 2,
                          )
                        ],
                      ),

                    // -----------------------
                    // 폴더 리스트
                    ...data.map((folder) {
                      final selected = folder.folderId == currentFolderId;

                      // -------------------
                      // 폴더 수정 시 UI
                      if (folder.folderId == _editFolderId) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: AppColor.primary,
                                ),
                                const Gap(10),
                                Expanded(
                                  child: TextField(
                                    controller: _editController,
                                    focusNode: _editFocusNode,
                                    decoration: const InputDecoration(
                                      hintText: '새 폴더 이름 입력',
                                      border: InputBorder.none,
                                    ),
                                    onSubmitted: (newName) {
                                      final editedName = newName.trim();
                                      if (editedName.isNotEmpty && editedName != folder.folderName) {
                                        widget.onEditFolder(
                                          folder.copyWith(folderName: editedName),
                                        );
                                      }
                                      setState(() {
                                        _editController.clear();
                                        _editFolderId = null;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 0,
                              color: AppColor.primary,
                              thickness: 2,
                            )
                          ],
                        );
                      } else {
                        // -------------------
                        // 폴더 리스트 UI
                        return MenuAnchor(
                          menuChildren: [
                              MenuItemButton(
                                onPressed: () {
                                  setState(() {
                                    _editFolderId = folder.folderId;
                                  });
                                  // 폴더 수정 시 textField에 Focus 주기
                                  Future.microtask(() => _editFocusNode.requestFocus());
                                },
                                leadingIcon: const Icon(Icons.edit),
                                child: const Text('폴더 수정하기'),
                              ),
                              MenuItemButton(
                                onPressed: () {
                                  widget.onDeleteFolder(folder);
                                },
                                leadingIcon: const Icon(Icons.delete),
                                child: const Text('폴더 삭제하기'),
                              ),
                          ],
                          style: MenuStyle(
                              backgroundColor: WidgetStateProperty.all(AppColor.white),
                          ),
                          builder: (context, controller, child) {
                            return ListTile(
                              title: Text(
                                folder.folderName,
                                style: AppTextStyle.bodyRegular.copyWith(
                                  color: selected ? AppColor.primary : AppColor.mediumGray,
                                ),
                              ),
                              tileColor: selected ? AppColor.paleBlue : AppColor.white,
                              leading: Icon(
                                Icons.folder,
                                color: selected ? AppColor.primary : AppColor.mediumGray,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onTap: () => widget.onClickFolder(folder),
                              onLongPress: () {
                                controller.open();
                              },
                            );
                          }
                        );
                      }
                    }),
                  ],
                ),
              )
            ],
          ),
          Error() => const SizedBox.shrink(),
        };
      },
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}
