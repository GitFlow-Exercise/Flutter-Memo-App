import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'pick_file.freezed.dart';

@freezed
abstract class PickFile with _$PickFile {
  const factory PickFile({
    required String type,
    required String fileName,
    required String fileExtension,
    required Uint8List bytes,
  }) = _PickFile;
}
