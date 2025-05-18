import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

part 'my_files_state.freezed.dart';

@freezed
abstract class MyFilesState with _$MyFilesState {
  const factory MyFilesState({
    required AsyncValue<List<Workbook>> workbookList,
    required bool showGridView,
  }) = _MyFilesState;
}
