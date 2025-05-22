import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  // Singleton 패턴 사용
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // API 호출이 발생할 때마다 호출
  Future<void> logApiCall({required String apiName}) async {
    await _analytics.logEvent(
      name: 'api_call',
      parameters: {
        'api_name': apiName,
      },
    );
  }

  /// API 호출 중 에러가 발생했을 때 호출
  Future<void> logApiError({
    required String apiName,
    required StackTrace stackTrace,
    required String errorMessage,
  }) async {
    await _analytics.logEvent(
      name: 'api_error',
      parameters: {
        'api_name': apiName,
        'stack_trace': stackTrace.toString(),
        'error_message': errorMessage,
      },
    );
  }

  /// 데이터베이스 호출 중 에러가 발생했을 때 호출
  // [job] : insert, update, delete 등
  Future<void> logDbError({
    required String job,
    required StackTrace stackTrace,
    required String errorMessage,
  }) async {
    await _analytics.logEvent(
      name: 'db_error',
      parameters: {
        'job': job,
        'stack_trace': stackTrace.toString(),
        'error_message': errorMessage,
      },
    );
  }

  /// 문제집이 생성될 때마다 호출
  Future<void> logWorkbookCreated({required String problemSetId}) async {
    await _analytics.logEvent(
      name: 'workbook_created',
    );
  }
}