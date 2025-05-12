import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';

class UploadRawTextField extends StatelessWidget {
  final void Function(String) onChnaged;
  final TextEditingController controller;
  const UploadRawTextField({
    super.key,
    required this.onChnaged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChnaged,
      controller: controller,
      maxLines: 12,
      decoration: const InputDecoration(
        fillColor: AppColor.textfieldGrey,
        border: OutlineInputBorder(),
        hintText: '여기에 텍스트를 붙여넣거나 입력하세요. 문단 구분을 위해 빈 줄을 사용하세요.',
      ),
    );
  }
}
