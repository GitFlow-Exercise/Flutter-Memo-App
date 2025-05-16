import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/domain/repository/workbook_repository.dart';

class ToggleBookmarkUseCase {
  final WorkbookRepository workbookRepository;

  ToggleBookmarkUseCase(this.workbookRepository);

  Future<Result<Workbook, AppException>> execute(Workbook workbook) async {
    final updatedWorkbook = workbook.copyWith(
      bookmark: !workbook.bookmark,
    );
    final result = await workbookRepository.updateWorkbook(updatedWorkbook);
    return result;
  }
}