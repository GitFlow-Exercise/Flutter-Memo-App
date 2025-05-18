import 'package:flutter_test/flutter_test.dart';
import 'package:mongo_ai/dashboard/data/data_source/folder_data_source.dart';
import 'package:mongo_ai/dashboard/data/data_source/folder_data_source_impl.dart';
import '../../utils/mock_supabase.dart';

void main() {
  final supabase = SupabaseMockHelper();
  late FolderDataSource folderDataSource;

  setUpAll(() {
    supabase.init();
    // AuthDataSource에 mockClient 주입
    folderDataSource = FolderDataSourceImpl(client: supabase.mockClient);
  });

  test('test', () async {
    final resp = await folderDataSource.getFoldersByCurrentTeamId(1);

    print(resp);
  });
}
