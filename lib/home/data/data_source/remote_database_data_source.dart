import 'package:memo_app/home/data/dto/base_dto.dart';

/// Supabase 데이터 접근 인터페이스
/// 데이터 조회
/// ```
/// final memo = await dataSource.getById<MemoDto>(
///   table: 'memos',
///   id: 'memo123',
///   fromJson: MemoDto.fromJson,
/// );
///
/// // 여러 데이터 조회
/// final memos = await dataSource.query<MemoDto>(
///   table: 'memos',
///   fromJson: MemoDto.fromJson,
///   filters: {'user_id': 'user123'},
/// );
/// ```
abstract interface class RemoteDataBaseDataSource {
  /// ID로 데이터 조회
  Future<T?> getById<T extends BaseDto>({
    required String table,
    required String id,
    required T Function(Map<String, dynamic>) fromJson,
  });

  /// 새 데이터 생성
  Future<T> create<T extends BaseDto>({
    required String table,
    required T data,
    required T Function(Map<String, dynamic>) fromJson,
  });

  /// 데이터 업데이트
  Future<T> update<T extends BaseDto>({
    required String table,
    required String id,
    required T data,
    required T Function(Map<String, dynamic>) fromJson,
  });

  /// 데이터 삭제
  Future<void> delete({required String table, required String id});

  /// 조건부 데이터 쿼리
  ///
  /// 사용 예시:
  /// ```dart
  /// // 기본 쿼리 (전체 데이터)
  /// final allMemos = await dataSource.query<MemoDto>(
  ///   table: 'memos',
  ///   fromJson: MemoDto.fromJson,
  /// );
  ///
  /// // 필터링 + 정렬 + 페이징
  /// final filteredMemos = await dataSource.query<MemoDto>(
  ///   table: 'memos',
  ///   fromJson: MemoDto.fromJson,
  ///   filters: {'user_id': 'user123', 'is_important': true},
  ///   orderBy: 'created_at',
  ///   ascending: false,
  ///   limit: 10,
  ///   offset: 20,
  /// );
  /// ```
  Future<List<T>> query<T extends BaseDto>({
    required String table,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
  });
}