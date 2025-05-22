import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

abstract interface class DashboardNavigationViewModel {
  // 문제집 선택 메서드
  Future<void> selectWorkbook(Workbook workbook);

  /// 워크북 리스트 새로고침
  Future<void> refreshWorkbookList();

  /// 북마크 토글
  Future<void> toggleBookmark(Workbook workbook);

  // 문제집 휴지통 이동
  Future<void> moveTrashWorkbook(Workbook workbook);

  Future<void> getProblemsByWorkbookId(int workbookId);
}