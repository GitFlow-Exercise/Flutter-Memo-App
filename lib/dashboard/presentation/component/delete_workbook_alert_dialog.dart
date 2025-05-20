import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';

class DeleteWorkbookAlertDialog extends StatelessWidget {
  final VoidCallback onDeleteWorkbook;
  final String title;
  const DeleteWorkbookAlertDialog({super.key, required this.onDeleteWorkbook, required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: const Text(
        '정말로 삭제하시겠습니까? 문제집이 영구 삭제되며, 이 작업은 되돌릴 수 없습니다.',
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDeleteWorkbook();
          },
          style: TextButton.styleFrom(foregroundColor: AppColor.destructive),
          child: const Text('삭제하기'),
        ),
      ],
    );
  }
}
