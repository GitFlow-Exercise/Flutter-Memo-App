import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/home/data/data_source/remote_database_data_source.dart';
import 'package:mongo_ai/home/data/dto/base_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase Data Source 구현
class RemoteDataBaseDataSourceImpl implements RemoteDataBaseDataSource {
  final SupabaseClient _client;

  RemoteDataBaseDataSourceImpl({required SupabaseClient client})
    : _client = client;

  @override
  Future<T?> getById<T extends BaseDto>({
    required String table,
    required String id,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final data =
          await _client.from(table).select().eq('id', id).maybeSingle();

      if (data == null) {
        return null;
      }

      return fromJson(data);
    } catch (e) {
      if (e is PostgrestException) {
        throw AppException.remoteDataBase(
          message: '데이터를 가져오는 중 오류가 발생했습니다: ${e.message}',
          error: e,
        );
      }

      throw AppException.remoteDataBase(
        message: '데이터를 가져오는 중 오류가 발생했습니다',
        error: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<T> create<T extends BaseDto>({
    required String table,
    required T data,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final jsonData = data.toJson();

      final responseData =
          await _client.from(table).insert(jsonData).select().single();

      return fromJson(responseData);
    } catch (e) {
      if (e is PostgrestException) {
        throw AppException.remoteDataBase(
          message: '데이터를 생성하는 중 오류가 발생했습니다: ${e.message}',
          error: e,
        );
      }

      throw AppException.remoteDataBase(
        message: '데이터를 생성하는 중 오류가 발생했습니다',
        error: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<T> update<T extends BaseDto>({
    required String table,
    required String id,
    required T data,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final jsonData = data.toJson();

      final responseData =
          await _client
              .from(table)
              .update(jsonData)
              .eq('id', id)
              .select()
              .single();

      return fromJson(responseData);
    } catch (e) {
      if (e is PostgrestException) {
        throw AppException.remoteDataBase(
          message: '데이터를 업데이트하는 중 오류가 발생했습니다: ${e.message}',
          error: e,
        );
      }

      throw AppException.remoteDataBase(
        message: '데이터를 업데이트하는 중 오류가 발생했습니다',
        error: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<void> delete({required String table, required String id}) async {
    try {
      await _client.from(table).delete().eq('id', id);
    } catch (e) {
      if (e is PostgrestException) {
        throw AppException.remoteDataBase(
          message: '데이터를 삭제하는 중 오류가 발생했습니다: ${e.message}',
          error: e,
        );
      }

      throw AppException.remoteDataBase(
        message: '데이터를 삭제하는 중 오류가 발생했습니다',
        error: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<List<T>> query<T extends BaseDto>({
    required String table,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = _client.from(table).select();

      if (filters != null) {
        for (final entry in filters.entries) {
          query = query.eq(entry.key, entry.value);
        }
      }

      if (orderBy != null) {
        query = query..order(orderBy, ascending: ascending);
      }

      if (limit != null) {
        query = query..limit(limit);
      }

      if (offset != null) {
        query = query..range(offset, offset + (limit ?? 10) - 1);
      }

      final data = await query;

      return (data as List)
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is PostgrestException) {
        throw AppException.remoteDataBase(
          message: '데이터를 조회하는 중 오류가 발생했습니다: ${e.message}',
          error: e,
        );
      }

      throw AppException.remoteDataBase(
        message: '데이터를 조회하는 중 오류가 발생했습니다',
        error: e,
        stackTrace: StackTrace.current,
      );
    }
  }
}
