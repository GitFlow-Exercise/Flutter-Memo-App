import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';

class DeleteAccountAlertDialog extends StatelessWidget {
  final VoidCallback onDeleteAccount;

  const DeleteAccountAlertDialog({super.key, required this.onDeleteAccount});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('회원 탈퇴 확인'),
      content: const Text(
        '정말로 탈퇴하시겠습니까? 모든 데이터가 영구적으로 삭제되며, 이 작업은 되돌릴 수 없습니다.',
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
            onDeleteAccount();
          },
          style: TextButton.styleFrom(foregroundColor: AppColor.destructive),
          child: const Text('탈퇴하기'),
        ),
      ],
    );
  }
}
