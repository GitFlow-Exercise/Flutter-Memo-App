import 'package:hive/hive.dart';
import 'package:memo_app/core/exception/app_exception.dart';
import 'package:memo_app/home/data/data_source/local_database_data_source.dart';
import 'package:memo_app/home/data/dto/base_dto.dart';
import 'package:uuid/uuid.dart';

/// Hive 로컬 데이터베이스 구현
class LocalDatabaseDataSourceImpl implements LocalDatabaseDataSource {
  final Map<String, Box> _boxes = {};
  final Uuid _uuid = const Uuid();

  /// 지정된 boxName의 Hive Box를 열거나 이미 열려있으면 가져옴
  Future<Box> _openBox(String boxName) async {
    if (_boxes.containsKey(boxName) && _boxes[boxName]!.isOpen) {
      return _boxes[boxName]!;
    }

    try {
      final box = await Hive.openBox(boxName);
      _boxes[boxName] = box;
      return box;
    } catch (e) {
      throw AppException.localDataBase(
        message: '로컬 데이터베이스를 열 수 없습니다: $boxName',
        error: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<T?> getById<T extends BaseDto>({
    required String boxName,
    required String id,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final box = await _openBox(boxName);
      final data = box.get(id);

      if (data == null) {
        return null;
      }

      return fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      throw AppException.localDataBase(
        message: '데이터를 가져오는 중 오류가 발생했습니다',
        error: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<T> create<T extends BaseDto>({
    required String boxName,
    required T data,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final box = await _openBox(boxName);
      final jsonData = data.toJson();

      // id가 없으면 새로 생성
      if (!jsonData.containsKey('id') ||
          jsonData['id'] == null ||
          jsonData['id'].toString().isEmpty) {
        jsonData['id'] = _uuid.v4();
      }

      final id = jsonData['id'];
      await box.put(id, jsonData);

      return fromJson(jsonData);
    } catch (e) {
      throw AppException.localDataBase(
        message: '데이터를 생성하는 중 오류가 발생했습니다',
        error: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<T> update<T extends BaseDto>({
    required String boxName,
    required String id,
    required T data,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final box = await _openBox(boxName);

      // 해당 ID의 데이터가 존재하는지 확인
      if (!box.containsKey(id)) {
        throw AppException.localDataBase(message: '업데이트할 데이터를 찾을 수 없습니다: $id');
      }

      final jsonData = data.toJson();
      // id 필드 업데이트 방지
      jsonData['id'] = id;

      await box.put(id, jsonData);
      return fromJson(jsonData);
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }

      throw AppException.localDataBase(
        message: '데이터를 업데이트하는 중 오류가 발생했습니다',
        error: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<void> delete({required String boxName, required String id}) async {
    try {
      final box = await _openBox(boxName);
      await box.delete(id);
    } catch (e) {
      throw AppException.localDataBase(
        message: '데이터를 삭제하는 중 오류가 발생했습니다',
        error: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<List<T>> query<T extends BaseDto>({
    required String boxName,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    try {
      final box = await _openBox(boxName);
      List<T> result = [];

      // 모든 데이터를 가져와서 메모리에서 필터링
      for (final key in box.keys) {
        final item = box.get(key);
        if (item != null) {
          final mapItem = Map<String, dynamic>.from(item);

          // 필터 적용
          bool matchesFilter = true;
          if (filters != null) {
            for (final entry in filters.entries) {
              if (mapItem[entry.key] != entry.value) {
                matchesFilter = false;
                break;
              }
            }
          }

          if (matchesFilter) {
            result.add(fromJson(mapItem));
          }
        }
      }

      // 정렬 적용
      if (orderBy != null) {
        result.sort((a, b) {
          final aValue = a.toJson()[orderBy];
          final bValue = b.toJson()[orderBy];

          if (aValue == null) return ascending ? -1 : 1;
          if (bValue == null) return ascending ? 1 : -1;

          int compareResult;

          if (aValue is String && bValue is String) {
            compareResult = aValue.compareTo(bValue);
          } else if (aValue is num && bValue is num) {
            compareResult = aValue.compareTo(bValue);
          } else if (aValue is DateTime && bValue is DateTime) {
            compareResult = aValue.compareTo(bValue);
          } else if (aValue is bool && bValue is bool) {
            compareResult = aValue == bValue ? 0 : (aValue ? 1 : -1);
          } else {
            compareResult = 0;
          }

          return ascending ? compareResult : -compareResult;
        });
      }

      // 페이징 적용
      if (offset != null || limit != null) {
        final start = offset ?? 0;
        final end = limit != null ? (start + limit) : result.length;

        if (start < result.length) {
          result = result.sublist(
            start,
            end > result.length ? result.length : end,
          );
        } else {
          result = [];
        }
      }

      return result;
    } catch (e) {
      throw AppException.localDataBase(
        message: '데이터를 조회하는 중 오류가 발생했습니다',
        error: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<void> clearBox({required String boxName}) async {
    try {
      final box = await _openBox(boxName);
      await box.clear();
    } catch (e) {
      throw AppException.localDataBase(
        message: '데이터를 모두 삭제하는 중 오류가 발생했습니다',
        error: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  @override
  bool isBoxOpen({required String boxName}) {
    return _boxes.containsKey(boxName) && _boxes[boxName]!.isOpen;
  }

  @override
  Future<void> closeBox({required String boxName}) async {
    if (_boxes.containsKey(boxName) && _boxes[boxName]!.isOpen) {
      await _boxes[boxName]!.close();
      _boxes.remove(boxName);
    }
  }
}
