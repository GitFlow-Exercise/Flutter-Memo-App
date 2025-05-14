import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/component/base_app_button.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/domain/model/pick_file.dart';
import 'package:printing/printing.dart';

// 파일 입력 화면
class UploadInputFile extends StatelessWidget {
  final PickFile? file;
  final VoidCallback pickPdf;
  final VoidCallback deleteFile;
  final void Function(DropzoneFileInterface event) onDropFile;
  final void Function(DropzoneViewController controller) setDropController;
  const UploadInputFile({
    super.key,
    required this.file,
    required this.pickPdf,
    required this.deleteFile,
    required this.onDropFile,
    required this.setDropController,
  });

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
          Stack(
            children: [
              Container(
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: PdfPreview(
                  build: (format) => file!.bytes,
                  maxPageWidth: 500,
                  allowPrinting: false,
                  allowSharing: false,
                  canChangePageFormat: false,
                  canChangeOrientation: false,
                  canDebug: false,
                ),
              ),
              Positioned(
                right: 16,
                top: 4,
                child: IconButton(
                  onPressed: deleteFile,
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        if (file == null)
          Stack(
            children: [
              // 웹일때만 drag&drop이 가능하도록 설정
              if (kIsWeb)
                Positioned.fill(
                  child: DropzoneView(
                    onCreated: setDropController,
                    onDropFile: onDropFile,
                  ),
                ),
              // 점선을 나태내주는 패키지 이용
              DottedBorder(
                color: AppColor.lightGrayBorder,
                radius: const Radius.circular(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: AppColor.textfieldGrey,
                    height: 400,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.picture_as_pdf_outlined,
                          color: AppColor.primary,
                          size: 40,
                        ),
                        const Gap(8),
                        Text(
                          'PDF 파일을 끌어서 놓거나 클릭하여 업로드하세요',
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.mediumGray,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          '파일은 한 개만 등록되며, 마지막 파일이 등록됩니다.',
                          style: AppTextStyle.captionRegular.copyWith(
                            color: AppColor.hintTextGrey,
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
                        BaseAppButton(onTap: pickPdf, text: '파일 선택하기'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
