import 'package:mongo_ai/auth/data/data_source/temp_storage_data_source.dart';
import 'package:mongo_ai/auth/data/dto/temp_user_dto.dart';
import 'package:mongo_ai/auth/data/mapper/store/temp_user_store_mapper.dart';
import 'package:mongo_ai/auth/domain/model/temp_user.dart';
import 'package:uuid/uuid.dart';

class TempStorageDataSourceImpl implements TempStorageDataSource {
  static final TempStorageDataSourceImpl _instance =
      TempStorageDataSourceImpl._internal();

  factory TempStorageDataSourceImpl() => _instance;

  TempStorageDataSourceImpl._internal();

  final Map<String, TempUserDto> _storage = {};
  final _uuid = const Uuid();

  @override
  String store(TempUser data) {
    final id = _uuid.v4();
    _storage[id] = data.toTempUserDto();
    return id;
  }

  @override
  TempUserDto? retrieve(String id) {
    return _storage[id];
  }

  @override
  void remove(String id) {
    _storage.remove(id);
  }

  @override
  void clear() {
    _storage.clear();
  }
}
