import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/create/presentation/create_complete/controller/create_complete_state.dart';
import 'package:mongo_ai/create/presentation/create_complete/controller/problem_editor_state.dart';
import 'package:mongo_ai/create/presentation/create_complete/widget/problem_content_editor.dart';
import 'package:mongo_ai/create/presentation/create_complete/widget/problem_options_editor.dart';
import 'package:mongo_ai/create/presentation/create_complete/widget/problem_question_editor.dart';
import 'package:mongo_ai/create/presentation/create_complete/widget/problem_title_editor.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';

class ProblemPreviewWidget extends StatefulWidget {
  final CreateCompleteState state;
  final TextEditingController titleController;
  final void Function(String) onTitleSubmitted;
  final void Function(int, Problem) onProblemUpdated;
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
            editorState.questionControllers[problem.number]?.text ??
            problem.question;
        final contentText =
            editorState.contentControllers[problem.number]?.text ??
            problem.passage;

        final updated = problem.copyWith(
          question: questionText,
          passage: contentText,
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
              ProblemTitleEditor(
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
                    editorState.questionControllers[problem.number];
                final contentController =
                    editorState.contentControllers[problem.number];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(24),
                    ProblemQuestionEditor(
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

                    ProblemContentEditor(
                      isEditMode: widget.state.isEditMode,
                      controller: contentController!,
                      content: problem.passage,
                      onChanged: (value) {
                        setState(() {
                          final updatedProblem = editorState
                              .editedProblems[index]
                              .copyWith(passage: value);
                          editorState = editorState.updateProblem(
                            index,
                            updatedProblem,
                          );
                        });
                      },
                    ),

                    const Gap(24),

                    ProblemOptionsEditor(
                      isEditMode: widget.state.isEditMode,
                      options: editorState.editedProblems[index].options,
                      problemId: problem.number,
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
