import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_event.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';

class CreateTemplateViewModel with ChangeNotifier {
  CreateTemplateState _state = const CreateTemplateState();
  CreateTemplateState get state => _state;

  final _eventController = StreamController<CreateTemplateEvent>();
  Stream<CreateTemplateEvent> get eventStream => _eventController.stream;

  @override
  void dispose() {
    _eventController.close();
    super.dispose();
  }
}