import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

part 'folder_state.freezed.dart';

@freezed
abstract class FolderState with _$FolderState {
  const factory FolderState({
    required AsyncValue<List<Workbook>> workbookList,
  }) = _RecentFilesState;
}
