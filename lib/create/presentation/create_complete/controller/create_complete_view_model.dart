import 'dart:async';
import 'dart:typed_data';
import 'package:mongo_ai/core/component/pdf_generator.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/extension/ref_extension.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/core/state/current_folder_id_state.dart';
import 'package:mongo_ai/core/state/current_team_id_state.dart';
import 'package:mongo_ai/core/utils/app_dialog.dart';
import 'package:mongo_ai/create/domain/model/create_complete_params.dart';
import 'package:mongo_ai/create/presentation/create_complete/controller/create_complete_state.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';
import 'package:mongo_ai/dashboard/data/dto/workbook_table_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_complete_view_model.g.dart';

@riverpod
class CreateCompleteViewModel extends _$CreateCompleteViewModel {
  @override
  CreateCompleteState build(CreateCompleteParams params) {
    return CreateCompleteState(
      bytes: Uint8List(0),
      problems: params.problems,
      isDoubleColumns: params.isDoubleColumns,
      problemTypes: params.problems.map((e) => e.problemType).toSet().toList(),
    );
  }

  void setFileName(String fileName) {
    state = state.copyWith(fileName: fileName);
  }

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  Future<void> toggleEditMode() async {
    bool isPremium = ref
        .read(authDataSourceProvider)
        .checkMetadata('is_premium');
    if (isPremium) {
      state = state.copyWith(isEditMode: !state.isEditMode);
    } else {
      ref.showDialog(
        builder: (context) {
          return AppDialog.paymentAlertDialog(
            title: '멤버십 구독자 전용 기능',
            content: '프로 플랜 구독하고\n 더 많은 기능을 사용해보세요!',
            buttonTap:
                () => ref.navigate(
                  Routes.paymentPlans,
                  extra: CreateCompleteParams(
                    problems: state.problems,
                    isDoubleColumns: state.isDoubleColumns,
                  ),
                ),
          );
        },
      );
    }
  }

  // pdf data 설정
  Future<Uint8List> setPdfData() async {
    String content = _convertProblemsToPdfContent(state.problems);

    // PDF 생성
    final pdfBytes = await PdfGenerator().generatePdf(
      headerText: state.title,
      contentsText: content,
      useDoubleColumn: state.isDoubleColumns,
    );
    state = state.copyWith(bytes: pdfBytes);
    return pdfBytes;
  }

  Future<void> downloadPdf() async {
    final useCase = ref.read(downloadPdfUseCase);
    final result = useCase.execute(
      pdfBytes: state.bytes,
      fileName: state.fileName,
    );
    switch (result) {
      case Success<void, AppException>():
        break;
      case Error<void, AppException>():
        ref.showSnackBar('다운로드 중 에러가 발생하였습니다.');
        break;
    }
  }

  // 문제 업데이트
  void updateProblem(int index, Problem updatedProblem) {
    final problems = List<Problem>.from(state.problems);
    problems[index] = updatedProblem;
    state = state.copyWith(problems: problems);
  }

  // 옵션 순서 변경
  void reorderOptions(int problemIndex, List<String> newOptions) {
    final problems = List<Problem>.from(state.problems);
    final problem = problems[problemIndex];
    problems[problemIndex] = problem.copyWith(options: newOptions);
    state = state.copyWith(problems: problems);
  }

  // 제목 업데이트
  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  // CompleteProblem 리스트를 마크다운 형식의 텍스트로 변환하는 함수
  String _convertProblemsToPdfContent(List<Problem> problems) {
    final StringBuffer buffer = StringBuffer();

    for (var problem in problems) {
      // 문제 번호와 질문 추가
      buffer.writeln('### ${problem.number}. ${problem.question}');
      buffer.writeln();

      // 본문 내용 추가
      buffer.writeln(problem.passage);
      buffer.writeln();

      // 선택지 추가
      final circledNumbers = ['①', '②', '③', '④', '⑤', '⑥', '⑦', '⑧', '⑨', '⑩'];
      for (int i = 0; i < problem.options.length; i++) {
        buffer.writeln('${circledNumbers[i]} ${problem.options[i]}');
      }

      // 문제 사이에 빈 줄 추가 (마지막 문제 제외)
      if (problem != problems.last) {
        buffer.writeln();
        buffer.writeln();
      }
    }

    return buffer.toString();
  }

  Future<bool> saveProblems() async {
    String? userId;
    final teamId = ref.watch(currentTeamIdStateProvider);
    final folderId = ref.watch(currentFolderIdStateProvider);
    final userProfile = ref.watch(getCurrentUserProfileProvider);

    userProfile.whenData((user) {
      switch (user) {
        case Success(data: final user):
          userId = user.userId;
        case Error():
          ref.showSnackBar('유저 정보를 불러오는데 실패했습니다.');
      }
    });

    if (teamId == null || folderId == null || userId == null) {
      ref.showSnackBar('필요한 정보를 불러오는 데 실패하였습니다.');
      return false;
    }

    final createdWorkbook = await ref
        .read(workbookRepositoryProvider)
        .createWorkbook(
          WorkbookTableDto(
            workbookName: state.title,
            teamId: teamId,
            folderId: folderId,
            userId: userId,
          ),
        );

    switch (createdWorkbook) {
      case Success(data: final workbook):
        final result = await ref
            .read(problemRepositoryProvider)
            .createProblems(state.problems, workbook.workbookId.toString());
        switch (result) {
          case Success():
            return true;
          case Error():
            ref.showSnackBar('문제집에 문제를 저장하는 데 실패하였습니다.');
            return false;
        }
      case Error():
        ref.showSnackBar('문제집 생성에 실패하였습니다.');
        return false;
    }
  }
}
