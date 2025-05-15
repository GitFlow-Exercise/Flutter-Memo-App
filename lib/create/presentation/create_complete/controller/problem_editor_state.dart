import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:mongo_ai/create/presentation/create_complete/controller/create_complete_state.dart';

part 'problem_editor_state.freezed.dart';

@freezed
abstract class ProblemEditorState with _$ProblemEditorState {
  const ProblemEditorState._();

  const factory ProblemEditorState({
    required Map<int, TextEditingController> questionControllers,
    required Map<int, TextEditingController> contentControllers,
    required List<CompleteProblem> editedProblems,
  }) = _ProblemEditorState;

  // 새로운 인스턴스 생성을 위한 팩토리 메서드
  factory ProblemEditorState.fromProblems(List<CompleteProblem> problems) {
    final questionControllers = <int, TextEditingController>{};
    final contentControllers = <int, TextEditingController>{};

    for (final problem in problems) {
      questionControllers[problem.id] = TextEditingController(
        text: problem.question,
      );
      contentControllers[problem.id] = TextEditingController(
        text: problem.content,
      );
    }

    return ProblemEditorState(
      questionControllers: questionControllers,
      contentControllers: contentControllers,
      editedProblems: List<CompleteProblem>.from(problems),
    );
  }

  // 리소스 해제
  void dispose() {
    for (final controller in questionControllers.values) {
      controller.dispose();
    }
    for (final controller in contentControllers.values) {
      controller.dispose();
    }
  }

  // 특정 문제 업데이트
  ProblemEditorState updateProblem(int index, CompleteProblem updatedProblem) {
    final newEditedProblems = List<CompleteProblem>.from(editedProblems);
    newEditedProblems[index] = updatedProblem;

    return copyWith(editedProblems: newEditedProblems);
  }
}
