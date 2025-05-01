import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_app/home/data/data_source/local_database_data_source.dart';
import 'package:memo_app/home/data/data_source/local_database_data_source_impl.dart';
import 'package:memo_app/home/data/data_source/remote_database_data_source.dart';
import 'package:memo_app/home/data/data_source/remote_database_data_source_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../home/data/data_source/home_data_source.dart';
import '../../home/data/data_source/home_data_source_impl.dart';
import '../../home/data/repository/home_repository_impl.dart';
import '../../home/domain/repository/home_repository.dart';
import '../../home/domain/use_case/get_home_info_use_case.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final localDatabaseProvider = Provider<LocalDatabaseDataSource>((ref) {
  return LocalDatabaseDataSourceImpl();
});

final remoteDatabaseProvider = Provider<RemoteDataBaseDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return RemoteDataBaseDataSourceImpl(client: client);
});

final homeDataSourceProvider = Provider<HomeDataSource>((ref) {
  return HomeDataSourceImpl();
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final dataSource = ref.watch(homeDataSourceProvider);
  return HomeRepositoryImpl(homeDataSource: dataSource);
});

final getHomeInfoUseCaseProvider = Provider<GetHomeInfoUseCase>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetHomeInfoUseCase(repository);
});
