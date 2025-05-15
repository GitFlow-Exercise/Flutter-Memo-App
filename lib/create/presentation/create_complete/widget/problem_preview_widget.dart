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
    if (oldWidget.state != widget.state) {
      _initControllers();
      editedProblems = List<CompleteProblem>.from(widget.state.problems);
    }

    prevEditMode = widget.state.isEditMode;
  }

  // 사용자가 명시적으로 호출해야 하는 저장 메서드
  void saveChanges() {
    if (widget.state.isEditMode) {
      for (var i = 0; i < editedProblems.length; i++) {
        widget.onProblemUpdated(i, editedProblems[i]);
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
                            final selection = questionController.selection;
                            // 변경사항을 임시 저장만 함
                            editedProblems[index] = CompleteProblem(
                              id: problem.id,
                              question: value,
                              content: editedProblems[index].content,
                              options: problem.options,
                            );
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (questionController.text == value) {
                                questionController.selection = selection;
                              }
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
                            // 변경사항을 임시 저장만 함
                            editedProblems[index] = CompleteProblem(
                              id: problem.id,
                              question: editedProblems[index].question,
                              content: value,
                              options: problem.options,
                            );
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
                            final options = List<String>.from(problem.options);
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final item = options.removeAt(oldIndex);
                            options.insert(newIndex, item);
                            widget.onOptionsReordered(index, options);
                          },
                          children:
                              problem.options.asMap().entries.map((
                                optionEntry,
                              ) {
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
                              }).toList(),
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

// class _ProblemPreviewWidgetState extends State<ProblemPreviewWidget> {
//   // 각 문제의 텍스트 컨트롤러를 저장할 맵
//   late Map<int, TextEditingController> questionControllers;
//   late Map<int, TextEditingController> contentControllers;

//   @override
//   void initState() {
//     super.initState();
//     _initControllers();
//   }

//   @override
//   void didUpdateWidget(ProblemPreviewWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.state != widget.state) {
//       _initControllers();
//     }
//   }

//   void _initControllers() {
//     // 컨트롤러 초기화
//     questionControllers = {};
//     contentControllers = {};

//     for (var i = 0; i < widget.state.problems.length; i++) {
//       final problem = widget.state.problems[i];
//       questionControllers[problem.id] = TextEditingController(
//         text: problem.question,
//       );
//       contentControllers[problem.id] = TextEditingController(
//         text: problem.content,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     // 컨트롤러 해제
//     for (var controller in questionControllers.values) {
//       controller.dispose();
//     }
//     for (var controller in contentControllers.values) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 650,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: AppColor.white,
//         border: Border.all(color: AppColor.lightGrayBorder),
//       ),
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(
//           maxHeight: 600, // 원하는 최대 높이로 조정
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               // 제목 편집 (기존 코드 유지)
//               widget.state.title.isEmpty || widget.state.isEditMode
//                   ? SizedBox(
//                     width: 300,
//                     child: TextField(
//                       controller: widget.titleController,
//                       textAlign: TextAlign.center,
//                       decoration: InputDecoration(
//                         hintText: '제목을 입력하세요',
//                         hintStyle: AppTextStyle.headingMedium.copyWith(
//                           color: AppColor.mediumGray,
//                         ),
//                         enabledBorder: const UnderlineInputBorder(
//                           borderSide: BorderSide(
//                             color: AppColor.lightGrayBorder,
//                           ),
//                         ),
//                         focusedBorder: const UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColor.deepBlack),
//                         ),
//                         isDense: true,
//                         contentPadding: EdgeInsets.zero,
//                       ),
//                       style: AppTextStyle.headingMedium.copyWith(
//                         color: AppColor.deepBlack,
//                       ),
//                       onSubmitted: widget.onTitleSubmitted,
//                     ),
//                   )
//                   : Text(
//                     widget.state.title,
//                     style: AppTextStyle.titleBold.copyWith(
//                       color: AppColor.deepBlack,
//                     ),
//                   ),
//               const Gap(24),

//               // 문제 목록
//               ...widget.state.problems.asMap().entries.map((entry) {
//                 final index = entry.key;
//                 final problem = entry.value;
//                 final questionController = questionControllers[problem.id];
//                 final contentController = contentControllers[problem.id];

//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Gap(24),

//                     // 문제 질문 (편집모드에 따라 TextField 또는 Text)
//                     widget.state.isEditMode
//                         ? TextField(
//                           controller: questionController,
//                           decoration: InputDecoration(
//                             hintText: '문제를 입력하세요',
//                             hintStyle: AppTextStyle.labelMedium.copyWith(
//                               color: AppColor.mediumGray,
//                             ),
//                             border: const OutlineInputBorder(),
//                           ),
//                           style: AppTextStyle.labelMedium.copyWith(
//                             color: AppColor.deepBlack,
//                           ),
//                           onChanged: (value) {
//                             if (questionController == null) return;
//                             final selection = questionController.selection;
//                             final updatedProblem = CompleteProblem(
//                               id: problem.id,
//                               question: value,
//                               content: problem.content,
//                               options: problem.options,
//                             );
//                             widget.onProblemUpdated(index, updatedProblem);
//                             // 커서 위치를 유지
//                             WidgetsBinding.instance.addPostFrameCallback((_) {
//                               if (questionController.text == value) {
//                                 questionController.selection = selection;
//                               }
//                             });
//                           },
//                           maxLines: null,
//                         )
//                         : Text(
//                           problem.question,
//                           style: AppTextStyle.labelMedium.copyWith(
//                             color: AppColor.deepBlack,
//                           ),
//                         ),
//                     const Gap(16),

//                     // 문제 내용 (편집모드에 따라 TextField 또는 Text)
//                     widget.state.isEditMode
//                         ? TextField(
//                           controller: contentController,
//                           decoration: InputDecoration(
//                             hintText: '문제 내용을 입력하세요',
//                             hintStyle: AppTextStyle.bodyMedium.copyWith(
//                               color: AppColor.mediumGray,
//                             ),
//                             border: const OutlineInputBorder(),
//                           ),
//                           style: AppTextStyle.bodyMedium.copyWith(
//                             color: AppColor.deepBlack,
//                           ),
//                           onChanged: (value) {
//                             final updatedProblem = CompleteProblem(
//                               id: problem.id,
//                               question: problem.question,
//                               content: value,
//                               options: problem.options,
//                             );
//                             widget.onProblemUpdated(index, updatedProblem);
//                           },
//                           maxLines: null,
//                         )
//                         : Text(
//                           problem.content,
//                           style: AppTextStyle.bodyMedium.copyWith(
//                             color: AppColor.deepBlack,
//                           ),
//                         ),
//                     const Gap(24),

//                     // 문제 옵션 (편집모드에 따라 ReorderableListView 또는 Column)
//                     widget.state.isEditMode
//                         ? ReorderableListView(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           onReorder: (oldIndex, newIndex) {
//                             final options = List<String>.from(problem.options);

//                             // ReorderableListView의 구현 방식 때문에 newIndex 조정이 필요함
//                             if (oldIndex < newIndex) {
//                               newIndex -= 1;
//                             }

//                             final item = options.removeAt(oldIndex);
//                             options.insert(newIndex, item);

//                             widget.onOptionsReordered(index, options);
//                           },
//                           children:
//                               problem.options.asMap().entries.map((
//                                 optionEntry,
//                               ) {
//                                 final optionIdx = optionEntry.key;
//                                 final optionValue = optionEntry.value;
//                                 return Container(
//                                   key: ValueKey('${problem.id}-$optionIdx'),
//                                   //margin: const EdgeInsets.only(bottom: 8),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     border: Border.all(
//                                       color: AppColor.lightGrayBorder,
//                                     ),
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                   child: ListTile(
//                                     title: Text(
//                                       '${optionIdx + 1}. $optionValue',
//                                       style: AppTextStyle.bodyMedium.copyWith(
//                                         color: AppColor.mediumGray,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                         )
//                         : Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children:
//                               problem.options.asMap().entries.map((
//                                 optionEntry,
//                               ) {
//                                 final optionIdx = optionEntry.key;
//                                 final optionValue = optionEntry.value;
//                                 return Text(
//                                   '${optionIdx + 1}. $optionValue',
//                                   style: AppTextStyle.bodyMedium.copyWith(
//                                     color: AppColor.mediumGray,
//                                     height: 2,
//                                   ),
//                                 );
//                               }).toList(),
//                         ),
//                   ],
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
