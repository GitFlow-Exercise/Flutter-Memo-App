import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/domain/repository/workbook_repository.dart';

class UpdateWorkbookUseCase {
  final WorkbookRepository _workbookRepository;

  UpdateWorkbookUseCase(this._workbookRepository);

  Future<Result<Workbook, AppException>> execute(Workbook workbook) async {
    final result = await _workbookRepository.updateWorkbook(workbook);
    return result;
  }
}