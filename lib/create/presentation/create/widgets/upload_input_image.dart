import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/domain/model/pick_file.dart';
import 'package:mongo_ai/create/presentation/create/widgets/upload_tip_box.dart';

// 이미지 입력 화면
class UploadInputImage extends StatelessWidget {
  final PickFile? file;
  final VoidCallback pickImage;
  final VoidCallback deleteFile;
  final void Function(DropzoneFileInterface event) onDropFile;
  final void Function(DropzoneViewController controller) setDropController;
  const UploadInputImage({
    super.key,
    required this.file,
    required this.pickImage,
    required this.deleteFile,
    required this.onDropFile,
    required this.setDropController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '이미지 업로드',
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColor.mediumGray,
              ),
            ),
            Text(
              '지원형식: PNG, JPG, JPEG',
              style: AppTextStyle.captionRegular.copyWith(
                color: AppColor.lightGray,
              ),
            ),
          ],
        ),
        const Gap(8),
        if (file != null)
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
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Image.memory(file!.bytes, fit: BoxFit.contain),
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
                        const Gap(8),
                        Text(
                          '이미지 파일을 끌어서 놓거나 클릭하여 업로드하세요',
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
                        InkWell(
                          onTap: pickImage,
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
                                const Gap(8),
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
          ),
        const Gap(16),
        const UploadTipBox(
          '텍스트가 선명하고 읽기 쉬운 이미지를 업로드하세요. 이미지에서 텍스트를 추출하여 문제를 생성합니다. 교과서 페이지, 학습 자료, 논문 등의 이미지가 적합합니다.',
        ),
        const Gap(40),
        Row(
          children: [
            const Icon(Icons.edit_outlined, color: AppColor.lightGray),
            const Gap(4),
            Text(
              '이미지에서 자동으로 텍스트를 추출합니다.',
              style: AppTextStyle.bodyRegular.copyWith(
                color: AppColor.lightGray,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
