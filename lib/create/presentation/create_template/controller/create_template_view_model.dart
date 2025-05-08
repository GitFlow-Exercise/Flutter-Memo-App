import 'dart:async';

import 'package:mongo_ai/create/presentation/create_template/controller/create_template_event.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_template_view_model.g.dart';

@riverpod
class CreateTemplateViewModel extends _$CreateTemplateViewModel {
  CreateTemplateState _state = const CreateTemplateState();
  CreateTemplateState get state => _state;

  final _eventController = StreamController<CreateTemplateEvent>();
  Stream<CreateTemplateEvent> get eventStream => _eventController.stream;

  @override
  CreateTemplateState build() {
    ref.onDispose(() {
      _eventController.close();
    });

    return const CreateTemplateState();
  }
}