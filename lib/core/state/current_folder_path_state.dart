import 'package:mongo_ai/dashboard/domain/model/folder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_folder_path_state.g.dart';

@riverpod
class CurrentFolderPathState extends _$CurrentFolderPathState {
  @override
  List<Folder> build() {
    // 초기에는 아무 팀도 선택되지 않음.
    // keepAlive로 리빌드 되지 않게 막음.
    ref.keepAlive();
    return <Folder>[];
  }

  /// 팀 선택 시 호출
  void setPath(List<Folder> path) {
    state = path;
  }

  /// 선택 해제 시 호출
  void clear() {
    state = [];
  }
}
