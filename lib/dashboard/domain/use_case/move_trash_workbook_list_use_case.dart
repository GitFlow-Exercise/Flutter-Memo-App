import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/domain/repository/workbook_repository.dart';

class MoveTrashWorkbookListUseCase {
  final WorkbookRepository workbookRepository;

  MoveTrashWorkbookListUseCase(this.workbookRepository);

  Future<Result<int, AppException>> execute(List<Workbook> workbookList) async {
    final result = await workbookRepository.moveTrashWorkbookList(workbookList);
    return result;
  }
}