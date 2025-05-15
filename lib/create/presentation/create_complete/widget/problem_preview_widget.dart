import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/presentation/%08create_complete/controller/create_complete_state.dart';
import 'package:mongo_ai/create/presentation/%08create_complete/controller/problem_editor_state.dart';

// ProblemEditorState 클래스 추가

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
  late ProblemEditorState editorState;
  late bool prevEditMode;

  @override
  void initState() {
    super.initState();
    _initEditorState();
    prevEditMode = widget.state.isEditMode;
  }

  void _initEditorState() {
    editorState = ProblemEditorState.fromProblems(widget.state.problems);
  }

  @override
  void didUpdateWidget(ProblemPreviewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 편집 모드가 변경되었을 때만 초기화
    if (oldWidget.state.isEditMode != widget.state.isEditMode) {
      editorState.dispose(); // 기존 컨트롤러 해제
      _initEditorState(); // 새로운 에디터 상태 초기화
    }

    prevEditMode = widget.state.isEditMode;
  }

  // 명시적으로 호출하는 저장 메서드
  void saveChanges() {
    if (widget.state.isEditMode) {
      for (var i = 0; i < editorState.editedProblems.length; i++) {
        final problem = editorState.editedProblems[i];
        final questionText =
            editorState.questionControllers[problem.id]?.text ??
            problem.question;
        final contentText =
            editorState.contentControllers[problem.id]?.text ?? problem.content;

        final updated = CompleteProblem(
          id: problem.id,
          question: questionText,
          content: contentText,
          options: problem.options,
        );

        widget.onProblemUpdated(i, updated);
      }
    }
  }

  @override
  void dispose() {
    editorState.dispose();
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
              EditableTitle(
                isEditMode: widget.state.isEditMode,
                title: widget.state.title,
                controller: widget.titleController,
                onSubmitted: widget.onTitleSubmitted,
              ),
              const Gap(24),
              ...widget.state.problems.asMap().entries.map((entry) {
                final index = entry.key;
                final problem = entry.value;
                final questionController =
                    editorState.questionControllers[problem.id];
                final contentController =
                    editorState.contentControllers[problem.id];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(24),
                    QuestionEditor(
                      isEditMode: widget.state.isEditMode,
                      controller: questionController!,
                      question: problem.question,
                      onChanged: (value) {
                        setState(() {
                          final updatedProblem = editorState
                              .editedProblems[index]
                              .copyWith(question: value);
                          editorState = editorState.updateProblem(
                            index,
                            updatedProblem,
                          );
                        });
                      },
                    ),

                    const Gap(16),

                    ContentEditor(
                      isEditMode: widget.state.isEditMode,
                      controller: contentController!,
                      content: problem.content,
                      onChanged: (value) {
                        setState(() {
                          final updatedProblem = editorState
                              .editedProblems[index]
                              .copyWith(content: value);
                          editorState = editorState.updateProblem(
                            index,
                            updatedProblem,
                          );
                        });
                      },
                    ),

                    const Gap(24),

                    OptionEditor(
                      isEditMode: widget.state.isEditMode,
                      options: editorState.editedProblems[index].options,
                      problemId: problem.id,
                      onReorder: (oldIndex, newIndex) {
                        final options = List<String>.from(
                          editorState.editedProblems[index].options,
                        );
                        if (oldIndex < newIndex) newIndex -= 1;
                        final item = options.removeAt(oldIndex);
                        options.insert(newIndex, item);

                        setState(() {
                          final updatedProblem = editorState
                              .editedProblems[index]
                              .copyWith(options: options);
                          editorState = editorState.updateProblem(
                            index,
                            updatedProblem,
                          );
                        });

                        widget.onOptionsReordered(index, options);
                      },
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

class EditableTitle extends StatelessWidget {
  final bool isEditMode;
  final String title;
  final TextEditingController controller;
  final void Function(String) onSubmitted;

  const EditableTitle({
    super.key,
    required this.isEditMode,
    required this.title,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    if (title.isEmpty || isEditMode) {
      return SizedBox(
        width: 300,
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: '제목을 입력하세요',
            hintStyle: AppTextStyle.headingMedium.copyWith(
              color: AppColor.mediumGray,
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
          style: AppTextStyle.headingMedium.copyWith(color: AppColor.deepBlack),
          onSubmitted: onSubmitted,
        ),
      );
    } else {
      return Text(
        title,
        style: AppTextStyle.titleBold.copyWith(color: AppColor.deepBlack),
      );
    }
  }
}

class QuestionEditor extends StatelessWidget {
  final bool isEditMode;
  final TextEditingController controller;
  final String question;
  final ValueChanged<String> onChanged;

  const QuestionEditor({
    super.key,
    required this.isEditMode,
    required this.controller,
    required this.question,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return isEditMode
        ? TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: '문제를 입력하세요',
            hintStyle: AppTextStyle.labelMedium.copyWith(
              color: AppColor.mediumGray,
            ),
            border: const OutlineInputBorder(),
          ),
          style: AppTextStyle.labelMedium.copyWith(color: AppColor.deepBlack),
          onChanged: onChanged,
          maxLines: null,
        )
        : Text(
          question,
          style: AppTextStyle.labelMedium.copyWith(color: AppColor.deepBlack),
        );
  }
}

class ContentEditor extends StatelessWidget {
  final bool isEditMode;
  final TextEditingController controller;
  final String content;
  final ValueChanged<String> onChanged;

  const ContentEditor({
    super.key,
    required this.isEditMode,
    required this.controller,
    required this.content,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return isEditMode
        ? TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: '문제 내용을 입력하세요',
            hintStyle: AppTextStyle.bodyMedium.copyWith(
              color: AppColor.mediumGray,
            ),
            border: const OutlineInputBorder(),
          ),
          style: AppTextStyle.bodyMedium.copyWith(color: AppColor.deepBlack),
          onChanged: onChanged,
          maxLines: null,
        )
        : Text(
          content,
          style: AppTextStyle.bodyMedium.copyWith(color: AppColor.deepBlack),
        );
  }
}

class OptionEditor extends StatelessWidget {
  final bool isEditMode;
  final List<String> options;
  final int problemId;
  final void Function(int oldIndex, int newIndex) onReorder;

  const OptionEditor({
    super.key,
    required this.isEditMode,
    required this.options,
    required this.problemId,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return isEditMode
        ? ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: onReorder,
          children:
              options.asMap().entries.map((entry) {
                final index = entry.key;
                final value = entry.value;
                return Container(
                  key: ValueKey('$problemId-$index'),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColor.lightGrayBorder),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListTile(
                    title: Text(
                      '${index + 1}. $value',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColor.mediumGray,
                      ),
                    ),
                  ),
                );
              }).toList(),
        )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              options.asMap().entries.map((entry) {
                final index = entry.key;
                final value = entry.value;
                return Text(
                  '${index + 1}. $value',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColor.mediumGray,
                    height: 2,
                  ),
                );
              }).toList(),
        );
  }
}
