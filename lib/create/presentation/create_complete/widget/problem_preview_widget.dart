import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/presentation/%08create_complete/controller/create_complete_state.dart';

class ProblemPreviewWidget extends StatefulWidget {
  final CreateCompleteState state;
  final TextEditingController titleController;
  final void Function(String) onTitleSubmitted;
  final void Function(int, CompleteProblem) onProblemUpdated;
  final void Function(int, List<String>) onOptionsReordered;

  const ProblemPreviewWidget({
    super.key,
    required this.state,
    required this.onTitleSubmitted,
    required this.titleController,
    required this.onProblemUpdated,
    required this.onOptionsReordered,
  });

  @override
  State<ProblemPreviewWidget> createState() => ProblemPreviewWidgetState();
}

class ProblemPreviewWidgetState extends State<ProblemPreviewWidget> {
  late Map<int, TextEditingController> questionControllers;
  late Map<int, TextEditingController> contentControllers;
  late List<CompleteProblem> editedProblems;
  late bool prevEditMode;

  @override
  void initState() {
    super.initState();
    _initControllers();
    editedProblems = List<CompleteProblem>.from(widget.state.problems);
    prevEditMode = widget.state.isEditMode;
  }

  @override
  void didUpdateWidget(ProblemPreviewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 예: 편집 모드가 껐다 켜졌을 때만 초기화
    if (oldWidget.state.isEditMode != widget.state.isEditMode) {
      _initControllers();
      editedProblems = List<CompleteProblem>.from(widget.state.problems);
    }

    prevEditMode = widget.state.isEditMode;
  }

  // 사용자가 명시적으로 호출해야 하는 저장 메서드
  void saveChanges() {
    if (widget.state.isEditMode) {
      for (var i = 0; i < editedProblems.length; i++) {
        final problem = editedProblems[i];
        final updated = CompleteProblem(
          id: problem.id,
          question: questionControllers[problem.id]?.text ?? problem.question,
          content: contentControllers[problem.id]?.text ?? problem.content,
          options: problem.options,
        );
        widget.onProblemUpdated(i, updated);
      }
    }
  }

  void _initControllers() {
    questionControllers = {};
    contentControllers = {};

    for (var i = 0; i < widget.state.problems.length; i++) {
      final problem = widget.state.problems[i];
      questionControllers[problem.id] = TextEditingController(
        text: problem.question,
      );
      contentControllers[problem.id] = TextEditingController(
        text: problem.content,
      );
    }
  }

  @override
  void dispose() {
    for (var controller in questionControllers.values) {
      controller.dispose();
    }
    for (var controller in contentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 650,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border.all(color: AppColor.lightGrayBorder),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 600),
        child: SingleChildScrollView(
          child: Column(
            children: [
              widget.state.title.isEmpty || widget.state.isEditMode
                  ? SizedBox(
                    width: 300,
                    child: TextField(
                      controller: widget.titleController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: '제목을 입력하세요',
                        hintStyle: AppTextStyle.headingMedium.copyWith(
                          color: AppColor.mediumGray,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColor.lightGrayBorder,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.deepBlack),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: AppTextStyle.headingMedium.copyWith(
                        color: AppColor.deepBlack,
                      ),
                      onSubmitted: widget.onTitleSubmitted,
                    ),
                  )
                  : Text(
                    widget.state.title,
                    style: AppTextStyle.titleBold.copyWith(
                      color: AppColor.deepBlack,
                    ),
                  ),
              const Gap(24),
              ...widget.state.problems.asMap().entries.map((entry) {
                final index = entry.key;
                final problem = entry.value;
                final questionController = questionControllers[problem.id];
                final contentController = contentControllers[problem.id];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(24),
                    widget.state.isEditMode
                        ? TextField(
                          controller: questionController,
                          decoration: InputDecoration(
                            hintText: '문제를 입력하세요',
                            hintStyle: AppTextStyle.labelMedium.copyWith(
                              color: AppColor.mediumGray,
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.deepBlack,
                          ),
                          onChanged: (value) {
                            if (questionController == null) return;

                            setState(() {
                              // 변경사항을 임시 저장만 함
                              editedProblems[index] = CompleteProblem(
                                id: problem.id,
                                question: value,
                                content: editedProblems[index].content,
                                options: editedProblems[index].options,
                              );
                            });
                          },
                          maxLines: null,
                        )
                        : Text(
                          problem.question,
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.deepBlack,
                          ),
                        ),
                    const Gap(16),
                    widget.state.isEditMode
                        ? TextField(
                          controller: contentController,
                          decoration: InputDecoration(
                            hintText: '문제 내용을 입력하세요',
                            hintStyle: AppTextStyle.bodyMedium.copyWith(
                              color: AppColor.mediumGray,
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.deepBlack,
                          ),
                          onChanged: (value) {
                            setState(() {
                              // 변경사항을 임시 저장만 함
                              editedProblems[index] = CompleteProblem(
                                id: problem.id,
                                question: editedProblems[index].question,
                                content: value,
                                options: editedProblems[index].options,
                              );
                            });
                          },
                          maxLines: null,
                        )
                        : Text(
                          problem.content,
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.deepBlack,
                          ),
                        ),
                    const Gap(24),
                    widget.state.isEditMode
                        ? ReorderableListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          onReorder: (oldIndex, newIndex) {
                            // 현재 편집된 문제 상태에서 옵션을 가져옴
                            final options = List<String>.from(
                              editedProblems[index].options,
                            );

                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final item = options.removeAt(oldIndex);
                            options.insert(newIndex, item);

                            setState(() {
                              editedProblems[index] = CompleteProblem(
                                id: problem.id,
                                question:
                                    questionControllers[problem.id]?.text ??
                                    problem.question,
                                content:
                                    contentControllers[problem.id]?.text ??
                                    problem.content,
                                options: options,
                              );
                            });

                            widget.onOptionsReordered(index, options);
                          },
                          children:
                              // 편집된 문제의 옵션을 보여줌
                              editedProblems[index].options.asMap().entries.map(
                                (optionEntry) {
                                  final optionIdx = optionEntry.key;
                                  final optionValue = optionEntry.value;
                                  return Container(
                                    key: ValueKey('${problem.id}-$optionIdx'),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: AppColor.lightGrayBorder,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        '${optionIdx + 1}. $optionValue',
                                        style: AppTextStyle.bodyMedium.copyWith(
                                          color: AppColor.mediumGray,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              problem.options.asMap().entries.map((
                                optionEntry,
                              ) {
                                final optionIdx = optionEntry.key;
                                final optionValue = optionEntry.value;
                                return Text(
                                  '${optionIdx + 1}. $optionValue',
                                  style: AppTextStyle.bodyMedium.copyWith(
                                    color: AppColor.mediumGray,
                                    height: 2,
                                  ),
                                );
                              }).toList(),
                        ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
