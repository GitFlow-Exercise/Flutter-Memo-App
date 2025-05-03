import 'dart:async';

import 'package:mongo_ai/create/presentation/controller/upload_raw_event.dart';
import 'package:mongo_ai/create/presentation/controller/upload_raw_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_raw_view_model.g.dart';

@riverpod
class UploadRawViewModel extends _$UploadRawViewModel {
  final _eventController = StreamController<UploadRawEvent>();

  Stream<UploadRawEvent> get eventStream => _eventController.stream;

  @override
  UploadRawState build() {
    ref.onDispose(() {
      _eventController.close();
    });

    return const UploadRawState();
  }
}
