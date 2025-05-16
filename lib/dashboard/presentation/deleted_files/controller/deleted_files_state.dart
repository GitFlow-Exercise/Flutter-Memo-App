import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

part 'deleted_files_state.freezed.dart';

@freezed
abstract class DeletedFilesState with _$DeletedFilesState{
  const factory DeletedFilesState({
    required AsyncValue<List<Workbook>> workbookList,
    required bool showGridView,
  }) = _DeletedFilesState;
}
