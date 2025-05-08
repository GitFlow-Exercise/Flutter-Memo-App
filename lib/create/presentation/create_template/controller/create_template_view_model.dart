import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_event.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_template_view_model.g.dart';

@riverpod
class CreateTemplateViewModel extends _$CreateTemplateViewModel {
  final _eventController = StreamController<CreateTemplateEvent>();
  Stream<CreateTemplateEvent> get eventStream => _eventController.stream;

  @override
  CreateTemplateState build() {
    final textEditingController = TextEditingController();

    ref.onDispose(() {
      _eventController.close();
      textEditingController.dispose();
    });

    return CreateTemplateState(textEditingController: textEditingController);
  }

  void toggleColumnsButton({required bool isSingleColumns}) {
    state = state.copyWith(isSingleColumns: isSingleColumns);
  }

  void changedContents({required String contents}) {
    state.textEditingController.text = contents;
  }

  void setProblem({required OpenAiResponse problem}) {
    changedContents(contents: problem.output[0].content[0].text);
    state = state.copyWith(problem: AsyncValue.data(problem));
  }
}