import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이미지 업로드',
          style: AppTextStyle.bodyMedium.copyWith(color: AppColor.mediumGray),
        ),
        const Gap(8),
        if (file != null)
          SizedBox(
            height: 250,
            width: double.infinity,
            child: Image.memory(file!.bytes, fit: BoxFit.cover),
          ),
        if (file == null)
          DottedBorder(
            color: AppColor.lightGrayBorder,
            radius: const Radius.circular(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 250,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_upload_outlined,
                      color: AppColor.primary,
                      size: 40,
                    ),
                    const Gap(16),
                    Text(
                      '이미지 파일을 끌어서 놓거나 클릭하여 업로드하세요',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColor.mediumGray,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        '최대 파일 크기 5MB',
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
                            const Icon(
                              Icons.folder_open_outlined,
                              color: AppColor.white,
                            ),
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
            ),
          ),
      ],
    );
  }
}

// 파일 입력 화면
class UploadInputFile extends StatelessWidget {
  final PickFile? file;
  final VoidCallback onTap;
  const UploadInputFile({super.key, required this.file, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PDF 파일 업로드',
          style: AppTextStyle.bodyMedium.copyWith(color: AppColor.mediumGray),
        ),
        const Gap(8),
        if (file != null)
          Container(
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: PdfPreview(
              build: (format) => file!.bytes,
              maxPageWidth: 400,
              allowPrinting: false,
              allowSharing: false,
              canChangePageFormat: false,
              canChangeOrientation: false,
              canDebug: false,
            ),
          ),
        if (file == null)
          DottedBorder(
            color: AppColor.lightGrayBorder,
            radius: const Radius.circular(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 250,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.picture_as_pdf_outlined,
                      color: AppColor.primary,
                      size: 40,
                    ),
                    const Gap(16),
                    Text(
                      'PDF 파일을 끌어서 놓거나 클릭하여 업로드하세요',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColor.mediumGray,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        '최대 파일 크기 5MB',
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
                        child: Text(
                          '파일 선택하기',
                          style: AppTextStyle.bodyRegular.copyWith(
                            color: AppColor.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
