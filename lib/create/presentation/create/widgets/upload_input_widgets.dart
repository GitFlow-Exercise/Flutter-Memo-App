import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/domain/model/pick_file.dart';
import 'package:mongo_ai/create/presentation/create/widgets/upload_raw_text_field.dart';
import 'package:printing/printing.dart';

// 텍스트 입력 화면
class UploadInputText extends StatelessWidget {
  final void Function(String) onChanged;
  final TextEditingController controller;
  const UploadInputText({
    super.key,
    required this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '텍스트 입력',
          style: AppTextStyle.bodyMedium.copyWith(color: AppColor.mediumGray),
        ),
        const SizedBox(height: 10),
        UploadRawTextField(onChanged: onChanged, controller: controller),
      ],
    );
  }
}

// 이미지 입력 화면
class UploadInputImage extends StatelessWidget {
  final PickFile? file;
  final VoidCallback onTap;
  const UploadInputImage({super.key, required this.file, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '이미지 업로드',
          style: AppTextStyle.bodyMedium.copyWith(color: AppColor.mediumGray),
        ),
        if (file != null)
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.memory(file!.bytes, fit: BoxFit.cover),
          ),
        if (file == null)
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '이미지 파일을 끌어서 놓거나 클릭하여 업로드하세요',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColor.mediumGray,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    '이미지 파일을 끌어서 놓거나 클릭하여 업로드하세요',
                    style: AppTextStyle.captionRegular.copyWith(
                      color: AppColor.lightGray,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.file_download),
                        const SizedBox(width: 8),
                        Text(
                          '파일 찾기',
                          style: AppTextStyle.bodyRegular.copyWith(
                            color: AppColor.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        // Container(
        //   height: 300,
        //   decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        //   child: Center(child: Image.memory(file.bytes, fit: BoxFit.contain)),
        // ),
      ],
    );
  }
}

// 파일 입력 화면
class UploadInputFile extends StatelessWidget {
  final PickFile file;
  const UploadInputFile({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Text('선택된 PDF: ${file.fileName}'),
        const SizedBox(height: 10),
        Container(
          height: 500,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: PdfPreview(
            build: (format) => file.bytes,
            maxPageWidth: 400,
            allowPrinting: false,
            allowSharing: false,
            canChangePageFormat: false,
            canChangeOrientation: false,
            canDebug: false,
          ),
        ),
      ],
    );
  }
}
