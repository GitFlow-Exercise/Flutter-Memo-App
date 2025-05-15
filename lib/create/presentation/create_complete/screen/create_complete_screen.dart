import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/presentation/create_complete/controller/create_complete_action.dart';
import 'package:mongo_ai/create/presentation/create_complete/controller/create_complete_state.dart';
import 'package:mongo_ai/create/presentation/create_complete/widget/problem_preview_widget.dart';

class CreateCompleteScreen extends StatefulWidget {
  final CreateCompleteState state;
  final void Function(CreateCompleteAction action) onAction;

  const CreateCompleteScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  State<CreateCompleteScreen> createState() => _CreateCompleteScreenState();
}

class _CreateCompleteScreenState extends State<CreateCompleteScreen> {
  late final TextEditingController fileNameController;
  late final TextEditingController titleController;

  final GlobalKey<ProblemPreviewWidgetState> problemPreviewKey =
      GlobalKey<ProblemPreviewWidgetState>();

  @override
  void initState() {
    super.initState();
    fileNameController = TextEditingController(
      text:
          widget.state.isEditMode
              ? widget.state.fileName.replaceAll('.pdf', '')
              : null,
    );
    titleController = TextEditingController(
      text: widget.state.isEditMode ? widget.state.title : null,
    );
  }

  @override
  void dispose() {
    fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(
              Icons.picture_as_pdf,
              size: 16,
              color: AppColor.lightGray,
            ),
            const Gap(2),
            widget.state.fileName.isEmpty || widget.state.isEditMode
                ? SizedBox(
                  width: 200,
                  child: TextField(
                    cursorColor: AppColor.deepBlack,
                    controller: fileNameController,
                    decoration: InputDecoration(
                      hintText: widget.state.isEditMode ? null : '파일명을 입력하세요',
                      hintStyle: AppTextStyle.bodyMedium.copyWith(
                        color: AppColor.lightGray,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor.lightGrayBorder),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor.deepBlack),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: AppColor.lightGray,
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        widget.onAction(
                          CreateCompleteAction.setFileName(
                            '${value.trim()}.pdf',
                          ),
                        );
                      }
                    },
                  ),
                )
                : Text(
                  widget.state.fileName,
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColor.lightGray,
                  ),
                ),
            const Gap(24),
            GestureDetector(
              onTap: () {
                // 편집 모드였다면 변경사항 저장
                if (widget.state.isEditMode) {
                  problemPreviewKey.currentState?.saveChanges();
                }
                widget.onAction(const CreateCompleteAction.toggleEditMode());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        widget.state.isEditMode
                            ? AppColor.primary
                            : AppColor.lightGrayBorder,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_square,
                      size: 16,
                      color:
                          widget.state.isEditMode
                              ? AppColor.primary
                              : AppColor.lightGray,
                    ),
                    const Gap(4),
                    Text(
                      '문제 수정',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color:
                            widget.state.isEditMode
                                ? AppColor.primary
                                : AppColor.lightGray,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Gap(16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.lightGrayBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: AppColor.paleBlue,
                child: Text(
                  '생성된 문제집 미리보기',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColor.mediumGray,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ProblemPreviewWidget(
                key: problemPreviewKey,
                state: widget.state,
                titleController: titleController,
                onTitleSubmitted: (title) {
                  // 제목 제출 로직
                  widget.onAction(CreateCompleteAction.setTitle(title));
                },
                onProblemUpdated: (index, updatedProblem) {
                  // 문제 업데이트 로직
                  widget.onAction(
                    CreateCompleteAction.updateProblem(index, updatedProblem),
                  );
                },
                onOptionsReordered: (index, newOptions) {
                  // 선택지 순서 변경 로직
                  widget.onAction(
                    CreateCompleteAction.reorderOptions(index, newOptions),
                  );
                },
              ),
            ],
          ),
        ),
        const Gap(30),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColor.paleBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info, size: 18, color: Color(0xff64B5F6)),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '문제집 정보',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColor.mediumGray,
                      ),
                    ),
                    const Gap(12),
                    Row(
                      children: [
                        Text(
                          '문제 유형:',
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.paleGray,
                          ),
                        ),
                        const Gap(12),
                        Text(
                          widget.state.problemTypes.join(', '),
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.paleGray,
                          ),
                        ),
                        const Gap(12),
                        Text(
                          '총 문제 수:',
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.paleGray,
                          ),
                        ),
                        const Gap(12),
                        Text(
                          '${widget.state.problems.length}문항',
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.paleGray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Gap(24),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed:
                () => widget.onAction(const CreateCompleteAction.previewPdf()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.file_download_outlined,
                  size: 16,
                  color: AppColor.white,
                ),
                const Gap(8),
                Text(
                  '미리보기',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColor.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
