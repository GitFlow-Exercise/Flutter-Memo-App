import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class UploadRawTextField extends StatelessWidget {
  final TextEditingController controller;
  const UploadRawTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: TextField(
        expands: true,
        maxLines: null,
        controller: controller,
        style: AppTextStyle.bodyRegular,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          fillColor: AppColor.textfieldGrey,
          filled: true,
          hintText: '여기에 텍스트를 붙여넣거나 입력하세요. 문단 구분을 위해 빈 줄을 사용하세요.',
          hintStyle: AppTextStyle.bodyRegular.copyWith(
            color: AppColor.hintTextGrey,
          ),
          hoverColor: AppColor.textfieldGrey,
          border: _baseBorder,
          disabledBorder: _baseBorder,
          errorBorder: _baseBorder,
          focusedBorder: _baseBorder,
          enabledBorder: _baseBorder,
        ),
      ),
    );
  }

  OutlineInputBorder get _baseBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: AppColor.lightGrayBorder),
  );
}
