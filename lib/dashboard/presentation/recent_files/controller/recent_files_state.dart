import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

part 'recent_files_state.freezed.dart';

@freezed
abstract class RecentFilesState with _$RecentFilesState {
  const factory RecentFilesState({
    required AsyncValue<List<Workbook>> workbookList,
  }) = _RecentFilesState;
}
