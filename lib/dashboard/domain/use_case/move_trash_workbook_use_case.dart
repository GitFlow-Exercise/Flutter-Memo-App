import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/domain/repository/workbook_repository.dart';

class MoveTrashWorkbookUseCase {
  final WorkbookRepository _workbookRepository;

  MoveTrashWorkbookUseCase(this._workbookRepository);

  Future<Result<Workbook, AppException>> execute(Workbook workbook) async {
    final updatedWorkbook = workbook.copyWith(
      deletedAt: DateTime.now(),
    );
    final result = await _workbookRepository.updateWorkbook(updatedWorkbook);
    return result;
  }
}