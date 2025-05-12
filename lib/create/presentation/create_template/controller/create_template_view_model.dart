import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mongo_ai/core/component/pdf_generator.dart';
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
    final pdfGenerator = PdfGenerator();

    ref.onDispose(() {
      _eventController.close();
      textEditingController.dispose();
    });

    return CreateTemplateState(
      textEditingController: textEditingController,
      pdfGenerator: pdfGenerator,
    );
  }

  void toggleColumnsButton({required bool isSingleColumns}) {
    state = state.copyWith(isSingleColumns: isSingleColumns);
  }

  void changedContents({required String contents}) {
    state.textEditingController.text = contents;
  }

  void setProblem({required OpenAiResponse problem}) {
    changedContents(contents: problem.getContent());
    print('------------------------');
    print('problem: ${problem.getContent()}');
    state = state.copyWith(problem: AsyncValue.data(problem));
  }

  void generatePdf({required String contents}) async {
    //TODO(ok): 추후 템플릿 확정 시 변경 예정, 다음 화면으로 Uint8List 전달
    // => 임시로 화면 이동하는 로직 추가하였습니다.(명우)
    final bytes = await state.pdfGenerator.generatePdf(
      headerText: 'Text',
      contentsText: contents,
      useDoubleColumn: !state.isSingleColumns,
    );
    _eventController.add(CreateTemplateEvent.createPdfWithTemplate(bytes));
  }
}
