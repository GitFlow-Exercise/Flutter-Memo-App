import 'dart:ui';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/state/selected_workbook_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

class SelectModeButtonWidget extends ConsumerWidget {
  final void Function() onToggleSelectMode;
  final void Function(Workbook workbook) onRemoveSelectedWorkbook;

  const SelectModeButtonWidget({super.key, required this.onToggleSelectMode, required this.onRemoveSelectedWorkbook});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelectMode = ref.watch(selectedWorkbookStateProvider).isSelectMode;
    final selectedWorkbookList = ref.watch(selectedWorkbookStateProvider).selectedWorkbooks;
    final height = MediaQuery.sizeOf(context).height * 0.6;

    if (!isSelectMode) {
      return SizedBox(
        width: 40,
        height: 40,
        child: ElevatedButton(
          onPressed: onToggleSelectMode,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.paleBlue,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AppColor.primary, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Center(child: Icon(Icons.edit, color: AppColor.primary)),
        ),
      );
    }

    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: -10, end: -6),
      badgeStyle: const badges.BadgeStyle(badgeColor: AppColor.destructive),
      badgeContent: Text(
        selectedWorkbookList.length.toString(),
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      child: SizedBox(
        width: 40,
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierColor: Colors.transparent,
              barrierLabel: 'Dismiss',
              pageBuilder: (_, __, ___) {
                return Stack(
                  children: [
                    Positioned(
                      top: 150,
                      right: 0,
                      width: 400,
                      height: MediaQuery.sizeOf(context).height * 0.6,
                      child: Material(
                        color: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            color: AppColor.paleBlue.withOpacity(0.2),
                            child: Column(
                              children: [
                                _buildHeader(),
                                Expanded(child: _buildList()),
                                _buildCancelButton(context),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              transitionBuilder:
                  (_, anim, __, child) => SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(1, 0), // 우측 바깥에서 시작
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(parent: anim, curve: Curves.easeOut),
                    ),
                    child: child,
                  ),
              transitionDuration: const Duration(milliseconds: 300),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.circle,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Center(child: Icon(Icons.folder, color: AppColor.white)),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColor.paleBlue,
      height: 50,
      alignment: Alignment.center,
      child: Text(
        '선택된 항목',
        style: AppTextStyle.bodyMedium.copyWith(
          color: AppColor.deepBlack,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildList() {
    return Consumer(
      builder: (context, ref, _) {
        final list = ref.watch(selectedWorkbookStateProvider).selectedWorkbooks;
        if (list.isEmpty) {
          return const Center(child: Text('선택된 항목이 없습니다.'));
        }
        return ListView(
          children: list.map((workbook) {
            return ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: Text(workbook.workbookName),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => onRemoveSelectedWorkbook(workbook),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        onToggleSelectMode();
      },
      child: Container(
        color: AppColor.paleBlue,
        height: 50,
        alignment: Alignment.center,
        child: Text(
          '선택 모드 취소',
          style: AppTextStyle.bodyMedium.copyWith(
            color: AppColor.destructive,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
