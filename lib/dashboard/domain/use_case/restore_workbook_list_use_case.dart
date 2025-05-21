import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/domain/repository/workbook_repository.dart';

class RestoreWorkbookListUseCase {
  final WorkbookRepository workbookRepository;

  RestoreWorkbookListUseCase(this.workbookRepository);

  Future<Result<int, AppException>> execute(List<Workbook> workbookList) async {
    final result = await workbookRepository.restoreWorkbookList(workbookList);
    return result;
  }
}